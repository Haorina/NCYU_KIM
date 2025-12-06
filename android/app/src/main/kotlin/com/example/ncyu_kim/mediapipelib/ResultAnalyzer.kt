package com.example.ncyu_kim.mediapipelib

import android.util.Log
import kotlin.math.abs
import kotlin.math.sqrt

class ResultAnalyzer(private val poseResult: PoseResult) {
    fun getLhcLabel(get3d: Boolean = false): String {
        val angleDict = getAllJointAnglesByName(get3d)
        return anglesToLhcLabel(angleDict)
    }

    private fun anglesToLhcLabel(angles: Map<String, Double>): String {
        if (angles.isEmpty()) {
            Log.w("ResultAnalyzer", "Empty angles, returning empty string")
            return "" // 與 Python 一致：無角度時返回空字串
        }
        val leftKnee = angles["left_knee"] ?: 180.0
        val rightKnee = angles["right_knee"] ?: 180.0
        val leftHip = angles["left_hip"] ?: 180.0
        val rightHip = angles["right_hip"] ?: 180.0
        val leftShoulder = angles["left_shoulder"] ?: 0.0
        val rightShoulder = angles["right_shoulder"] ?: 0.0
        val label = when {
            leftKnee <= 30.0 || rightKnee <= 30.0 -> "A5-3"
            leftKnee <= 45.0 || rightKnee <= 45.0 -> "A5-2"
            leftKnee <= 90.0 || rightKnee <= 90.0 -> "A5-1"
            leftHip <= 100.0 || rightHip <= 100.0 -> "A4-2"
            leftHip <= 120.0 || rightHip <= 120.0 -> "A4-1"
            leftHip <= 140.0 || rightHip <= 140.0 -> "A3-2"
            leftHip <= 160.0 || rightHip <= 160.0 -> "A3-1"
            leftShoulder > 90.0 || rightShoulder > 90.0 -> "A2"
            else -> "A1"
        }
        Log.d("ResultAnalyzer", "anglesToLhcLabel: angles=$angles, label=$label")
        return label
    }

    fun getAllJointAnglesByName(get3d: Boolean = false): Map<String, Double> {
        val allAngles = mutableMapOf<String, Double>()
        for ((center, pair) in JOINT_NAME_DICT) {
            val pos1 = poseResult.getKptPosByName(pair[0], get3d)
            val pos2 = poseResult.getKptPosByName(pair[1], get3d)
            val centerPos = poseResult.getKptPosByName(center, get3d)
            if (pos1 != null && pos2 != null && centerPos != null &&
                pos1.isNotEmpty() && pos2.isNotEmpty() && centerPos.isNotEmpty()) {
                val angle = Calculator.getAngleBy3Points(pos1, pos2, centerPos)
                allAngles[center] = angle
            } else {
                Log.w("ResultAnalyzer", "Missing positions for joint $center: pos1=$pos1, pos2=$pos2, centerPos=$centerPos")
            }
        }
        Log.d("ResultAnalyzer", "getAllJointAnglesByName: angles=$allAngles")
        return allAngles
    }

    fun checkIfTrunkIsTwistedOrLateralInclination(get3d: Boolean = false): Boolean {
        val result = checkIfTrunkIsTwisted(get3d) || checkIfTrunkIsLateralInclination(get3d)
        Log.d("ResultAnalyzer", "checkIfTrunkIsTwistedOrLateralInclination: result=$result")
        return result
    }

    fun checkIfTrunkIsTwisted(get3d: Boolean = false): Boolean {
        val twistedAngleThreshold = 15.0
        val angleXZ = getPoseShoulderHipStaggeredAngleXZ()
        val result = angleXZ > twistedAngleThreshold
        Log.d("ResultAnalyzer", "checkIfTrunkIsTwisted: angleXZ=$angleXZ, result=$result")
        return result
    }

    fun checkIfTrunkIsLateralInclination(get3d: Boolean = false): Boolean {
        val heightDiffThreshold = 0.06
        val leftShoulder = poseResult.getKptPosByName("left_shoulder", true)
        val rightShoulder = poseResult.getKptPosByName("right_shoulder", true)
        if (leftShoulder == null || rightShoulder == null || leftShoulder.size <= 1 || rightShoulder.size <= 1) {
            Log.w("ResultAnalyzer", "Missing shoulder positions for lateral inclination")
            return false
        }
        val shoulderDiff = abs(leftShoulder[1] - rightShoulder[1])
        val result = shoulderDiff > heightDiffThreshold
        Log.d("ResultAnalyzer", "checkIfTrunkIsLateralInclination: shoulderDiff=$shoulderDiff, result=$result")
        return result
    }

    fun checkIfHandsAtADistance(get3d: Boolean = false): Boolean {
        val distThreshold = 0.4
        val leftWrist = poseResult.getKptPosByName("left_wrist", true)
        val rightWrist = poseResult.getKptPosByName("right_wrist", true)
        val leftHip = poseResult.getKptPosByName("left_hip", true)
        val rightHip = poseResult.getKptPosByName("right_hip", true)
        if (leftWrist == null || rightWrist == null || leftHip == null || rightHip == null ||
            leftWrist.size < 3 || rightWrist.size < 3 || leftHip.size < 3 || rightHip.size < 3) {
            Log.w("ResultAnalyzer", "Missing positions for hands at a distance")
            return false
        }
        val gravityX = (leftHip[0] + rightHip[0]) / 2.0
        val gravityZ = (leftHip[2] + rightHip[2]) / 2.0
        val leftDist = sqrt((leftWrist[0] - gravityX) * (leftWrist[0] - gravityX) +
                (leftWrist[2] - gravityZ) * (leftWrist[2] - gravityZ))
        val rightDist = sqrt((rightWrist[0] - gravityX) * (rightWrist[0] - gravityX) +
                (rightWrist[2] - gravityZ) * (rightWrist[2] - gravityZ))
        val result = leftDist > distThreshold || rightDist > distThreshold
        Log.d("ResultAnalyzer", "checkIfHandsAtADistance: leftDist=$leftDist, rightDist=$rightDist, result=$result")
        return result
    }

    fun checkIfArmsRaised(get3d: Boolean = false): Boolean {
        val raisedAngleThreshold = 60.0
        fun isArmRaised(side: String): Boolean {
            val shoulderAngle = getJointAngleByName("${side}_shoulder", get3d)
            val shoulderY = poseResult.getKptPosByName("${side}_shoulder", get3d)?.getOrNull(1)?.times(-1.0) ?: return false
            val elbowY = poseResult.getKptPosByName("${side}_elbow", get3d)?.getOrNull(1)?.times(-1.0) ?: return false
            val wristY = poseResult.getKptPosByName("${side}_wrist", get3d)?.getOrNull(1)?.times(-1.0) ?: return false
            val result = shoulderAngle > raisedAngleThreshold && shoulderY > wristY && wristY > elbowY
            Log.d("ResultAnalyzer", "isArmRaised($side): shoulderAngle=$shoulderAngle, shoulderY=$shoulderY, wristY=$wristY, elbowY=$elbowY, result=$result")
            return result
        }
        return isArmRaised("left") || isArmRaised("right")
    }

    fun checkIfHandsAboveShoulder(get3d: Boolean = false): Boolean {
        val leftWristY = poseResult.getKptPosByName("left_wrist", get3d)?.getOrNull(1)?.times(-1.0) ?: return false
        val leftShoulderY = poseResult.getKptPosByName("left_shoulder", get3d)?.getOrNull(1)?.times(-1.0) ?: return false
        val rightWristY = poseResult.getKptPosByName("right_wrist", get3d)?.getOrNull(1)?.times(-1.0) ?: return false
        val rightShoulderY = poseResult.getKptPosByName("right_shoulder", get3d)?.getOrNull(1)?.times(-1.0) ?: return false
        val result = leftWristY > leftShoulderY || rightWristY > rightShoulderY
        Log.d("ResultAnalyzer", "checkIfHandsAboveShoulder: leftWristY=$leftWristY, leftShoulderY=$leftShoulderY, rightWristY=$rightWristY, rightShoulderY=$rightShoulderY, result=$result")
        return result
    }

    private fun getJointAngleByName(centerJointName: String, get3d: Boolean = false): Double {
        val pair = JOINT_NAME_DICT[centerJointName] ?: return 0.0
        val pos1 = poseResult.getKptPosByName(pair[0], get3d)
        val pos2 = poseResult.getKptPosByName(pair[1], get3d)
        val centerPos = poseResult.getKptPosByName(centerJointName, get3d)
        if (pos1 == null || pos2 == null || centerPos == null) {
            Log.w("ResultAnalyzer", "Missing positions for joint $centerJointName")
            return 0.0
        }
        return Calculator.getAngleBy3Points(pos1, pos2, centerPos)
    }

    private fun getPoseShoulderHipStaggeredAngleXZ(): Double {
        val shoulderL = poseResult.getKptPosByName("left_shoulder", true)
        val shoulderR = poseResult.getKptPosByName("right_shoulder", true)
        val hipL = poseResult.getKptPosByName("left_hip", true)
        val hipR = poseResult.getKptPosByName("right_hip", true)
        if (shoulderL == null || shoulderR == null || hipL == null || hipR == null ||
            shoulderL.size < 3 || shoulderR.size < 3 || hipL.size < 3 || hipR.size < 3) {
            Log.w("ResultAnalyzer", "Missing positions for shoulder-hip angle XZ")
            return 0.0
        }
        val shoulderVec = listOf(
            listOf(shoulderL[0], shoulderL[2]),
            listOf(shoulderR[0], shoulderR[2])
        )
        val hipVec = listOf(
            listOf(hipL[0], hipL[2]),
            listOf(hipR[0], hipR[2])
        )
        return Calculator.getAngleBetweenTwoLinesPosition(shoulderVec, hipVec)
    }

    companion object {
        val JOINT_NAME_DICT = mapOf(
            "left_shoulder" to listOf("left_elbow", "left_hip"),
            "right_shoulder" to listOf("right_elbow", "right_hip"),
            "left_hip" to listOf("left_shoulder", "left_knee"),
            "right_hip" to listOf("right_shoulder", "right_knee"),
            "left_knee" to listOf("left_hip", "left_ankle"),
            "right_knee" to listOf("right_hip", "right_ankle")
        )
    }
}
