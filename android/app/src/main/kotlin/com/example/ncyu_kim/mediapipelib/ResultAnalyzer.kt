package com.example.ncyu_kim.mediapipelib

import android.util.Log
import kotlin.math.abs
import kotlin.math.sqrt
import kotlin.math.pow


class ResultAnalyzer(private val poseResult: PoseResult) {
    fun getLhcLabel(get3d: Boolean = false): String {
        val angleDict = getAllJointAnglesByName(get3d)
        return anglesToLhcLabel(angleDict)
    }

    private fun anglesToLhcLabel(angles: Map<String, Double>): String {
        if (angles.isEmpty()) return ""
        val leftKnee = angles["left_knee"] ?: 180.0
        val rightKnee = angles["right_knee"] ?: 180.0
        val leftHip = angles["left_hip"] ?: 180.0
        val rightHip = angles["right_hip"] ?: 180.0
        val leftShoulder = angles["left_shoulder"] ?: 0.0
        val rightShoulder = angles["right_shoulder"] ?: 0.0

        return when {
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
    }

    fun getAllJointAnglesByName(get3d: Boolean = false): Map<String, Double> {
        val allAngles = mutableMapOf<String, Double>()
        for ((center, pair) in JOINT_NAME_DICT) {
            val pos1 = poseResult.getKptPosByName(pair[0], get3d)
            val pos2 = poseResult.getKptPosByName(pair[1], get3d)
            val centerPos = poseResult.getKptPosByName(center, get3d)
            if (pos1 != null && pos2 != null && centerPos != null) {
                val angle = Calculator.getAngleBy3Points(pos1, pos2, centerPos)
                allAngles[center] = angle
            }
        }
        return allAngles
    }

    fun checkIfTrunkIsTwistedOrLateralInclination(get3d: Boolean = false): Boolean {
        return checkIfTrunkIsTwisted(get3d) || checkIfTrunkIsLateralInclination(get3d)
    }

    fun checkIfTrunkIsTwisted(get3d: Boolean = false): Boolean {
        val angleXZ = getPoseShoulderHipStaggeredAngleXZ()
        Log.d("ResultAnalyzer", "Trunk twisted angle XZ: $angleXZ")
        return angleXZ > 15.0
    }

    fun checkIfTrunkIsLateralInclination(get3d: Boolean = false): Boolean {
        val leftShoulder = poseResult.getKptPosByName("left_shoulder", true)
        val rightShoulder = poseResult.getKptPosByName("right_shoulder", true)
        if (leftShoulder == null || rightShoulder == null) return false

        // 確保使用絕對值（與 Python 一致）
        val diff = abs(leftShoulder[1] - rightShoulder[1])
        Log.d("ResultAnalyzer", "Lateral inclination diff: $diff")
        return diff > 0.06
    }

    fun checkIfHandsAtADistance(get3d: Boolean = false): Boolean {
        val leftWrist = poseResult.getKptPosByName("left_wrist", true)
        val rightWrist = poseResult.getKptPosByName("right_wrist", true)
        val leftHip = poseResult.getKptPosByName("left_hip", true)
        val rightHip = poseResult.getKptPosByName("right_hip", true)
        if (leftWrist == null || rightWrist == null || leftHip == null || rightHip == null) return false

        val gravityX = (leftHip[0] + rightHip[0]) / 2.0
        val gravityZ = (leftHip[2] + rightHip[2]) / 2.0

        val leftDist = sqrt((leftWrist[0] - gravityX).pow(2) + (leftWrist[2] - gravityZ).pow(2))
        val rightDist = sqrt((rightWrist[0] - gravityX).pow(2) + (rightWrist[2] - gravityZ).pow(2))

        Log.d("ResultAnalyzer", "Hands at distance - left: $leftDist, right: $rightDist")
        return leftDist > 0.4 || rightDist > 0.4
    }

    fun checkIfArmsRaised(get3d: Boolean = false): Boolean {
        fun isRaised(side: String): Boolean {
            val shoulderAngle = getJointAngleByName("${side}_shoulder", get3d)
            val shoulderY = poseResult.getKptPosByName("${side}_shoulder", get3d)?.getOrNull(1) ?: return false
            val elbowY = poseResult.getKptPosByName("${side}_elbow", get3d)?.getOrNull(1) ?: return false
            val wristY = poseResult.getKptPosByName("${side}_wrist", get3d)?.getOrNull(1) ?: return false

            // 修改：Y 軸反轉後再比較（與 Python 一致）
            val shoulderYInv = shoulderY * -1
            val elbowYInv = elbowY * -1
            val wristYInv = wristY * -1

            val result = shoulderAngle > 60.0 && shoulderYInv > wristYInv && wristYInv > elbowYInv
            Log.d("ResultAnalyzer", "Arms raised check ($side): angle=$shoulderAngle, shoulderY=$shoulderYInv, elbowY=$elbowYInv, wristY=$wristYInv, result=$result")
            return result
        }
        return isRaised("left") || isRaised("right")
    }

    fun checkIfHandsAboveShoulder(get3d: Boolean = false): Boolean {
        val lw = poseResult.getKptPosByName("left_wrist", get3d)?.getOrNull(1) ?: return false
        val ls = poseResult.getKptPosByName("left_shoulder", get3d)?.getOrNull(1) ?: return false
        val rw = poseResult.getKptPosByName("right_wrist", get3d)?.getOrNull(1) ?: return false
        val rs = poseResult.getKptPosByName("right_shoulder", get3d)?.getOrNull(1) ?: return false

        // 修改：Y 軸反轉後再比較（與 Python 一致）
        val lwInv = lw * -1
        val lsInv = ls * -1
        val rwInv = rw * -1
        val rsInv = rs * -1

        val result = lwInv > lsInv || rwInv > rsInv
        Log.d("ResultAnalyzer", "Hands above shoulder - left: $lwInv > $lsInv = ${lwInv > lsInv}, right: $rwInv > $rsInv = ${rwInv > rsInv}, result=$result")
        return result
    }

    private fun getJointAngleByName(centerJointName: String, get3d: Boolean = false): Double {
        val pair = JOINT_NAME_DICT[centerJointName] ?: return 0.0
        val pos1 = poseResult.getKptPosByName(pair[0], get3d) ?: return 0.0
        val pos2 = poseResult.getKptPosByName(pair[1], get3d) ?: return 0.0
        val center = poseResult.getKptPosByName(centerJointName, get3d) ?: return 0.0

        return Calculator.getAngleBy3Points(pos1, pos2, center)
    }

    private fun getPoseShoulderHipStaggeredAngleXZ(): Double {
        val sl = poseResult.getKptPosByName("left_shoulder", true) ?: return 0.0
        val sr = poseResult.getKptPosByName("right_shoulder", true) ?: return 0.0
        val hl = poseResult.getKptPosByName("left_hip", true) ?: return 0.0
        val hr = poseResult.getKptPosByName("right_hip", true) ?: return 0.0

        val shoulderVec = listOf(listOf(sl[0], sl[2]), listOf(sr[0], sr[2]))
        val hipVec = listOf(listOf(hl[0], hl[2]), listOf(hr[0], hr[2]))

        return Calculator.getAngleBetweenTwoLinesPosition(shoulderVec, hipVec)
    }
}