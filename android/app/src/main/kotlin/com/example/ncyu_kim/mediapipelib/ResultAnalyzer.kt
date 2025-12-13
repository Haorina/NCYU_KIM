package com.example.ncyu_kim.mediapipelib

import android.util.Log
import kotlin.math.abs
import kotlin.math.pow
import kotlin.math.sqrt

class ResultAnalyzer(private val poseResult: PoseResult) {

    // ===== Python: get_all_joint_angles_by_name + angles_to_lhc_label =====
    fun getLhcLabel(): String {
        val angleDict = getAllJointAnglesByName()
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

        // 完整對齊 Python calculator.py: angles_to_lhc_label
        return when {
            leftKnee <= 30.0 || rightKnee <= 30.0 -> "A5-3"
            leftKnee <= 45.0 || rightKnee <= 45.0 -> "A5-2"
            leftKnee <= 90.0 || rightKnee <= 90.0 -> "A5-1"
            leftHip <= 100.0 || rightHip <= 100.0 -> "A4-2"
            leftHip <= 120.0 || rightHip <= 120.0 -> "A4-1"
            leftHip <= 140.0 || rightHip <= 140.0 -> "A3-2"
            leftHip <= 160.0 || rightHip <= 160.0 -> "A3-1"
            // Python: left_shoulder > 90 and right_shoulder > 90
            leftShoulder > 90.0 && rightShoulder > 90.0 -> "A2"
            else -> "A1"
        }
    }

    fun getAllJointAnglesByName(): Map<String, Double> {
        val allAngles = mutableMapOf<String, Double>()
        for ((center, pair) in JOINT_NAME_DICT) {
            val pos1 = poseResult.getKptPosByName(pair[0])
            val pos2 = poseResult.getKptPosByName(pair[1])
            val centerPos = poseResult.getKptPosByName(center)
            if (pos1 != null && pos2 != null && centerPos != null &&
                pos1.size >= 3 && pos2.size >= 3 && centerPos.size >= 3
            ) {
                val angle = Calculator.getAngleBy3Points(pos1, pos2, centerPos)
                allAngles[center] = angle
            }
        }
        return allAngles
    }

    fun getJointAngleByName(centerJointName: String): Double {
        val pair = JOINT_NAME_DICT[centerJointName] ?: return 0.0
        val pos1 = poseResult.getKptPosByName(pair[0]) ?: return 0.0
        val pos2 = poseResult.getKptPosByName(pair[1]) ?: return 0.0
        val center = poseResult.getKptPosByName(centerJointName) ?: return 0.0
        return Calculator.getAngleBy3Points(pos1, pos2, center)
    }

    // ===== Python: get_center_position_by_2_hand =====
    fun getCenterPositionBy2Hand(): List<Double> {
        val leftHand = poseResult.getKptPosByName("left_wrist") ?: return emptyList()
        val rightHand = poseResult.getKptPosByName("right_wrist") ?: return emptyList()
        if (leftHand.size < 3 || rightHand.size < 3) return emptyList()
        return listOf(
            (leftHand[0] + rightHand[0]) / 2.0,
            (leftHand[1] + rightHand[1]) / 2.0,
            (leftHand[2] + rightHand[2]) / 2.0
        )
    }

    // ===== Python: get_body_gravity_position =====
    fun getBodyGravityPosition(): List<Double> {
        val leftShoulder = poseResult.getKptPosByName("left_shoulder") ?: return emptyList()
        val rightShoulder = poseResult.getKptPosByName("right_shoulder") ?: return emptyList()
        val leftHip = poseResult.getKptPosByName("left_hip") ?: return emptyList()
        val rightHip = poseResult.getKptPosByName("right_hip") ?: return emptyList()
        if (leftShoulder.size < 3 || rightShoulder.size < 3 || leftHip.size < 3 || rightHip.size < 3) return emptyList()

        val centerHip = listOf(
            (leftHip[0] + rightHip[0]) / 2.0,
            (leftHip[1] + rightHip[1]) / 2.0,
            (leftHip[2] + rightHip[2]) / 2.0
        )

        return Calculator.getTriangleGravityPosition(leftShoulder, rightShoulder, centerHip)
    }

    // ===== Python: get_pose_shoulder_hip_staggered_angle_xz =====
    fun getPoseShoulderHipStaggeredAngleXZ(): Double {
        val sl = poseResult.getKptPosByName("left_shoulder") ?: return 0.0
        val sr = poseResult.getKptPosByName("right_shoulder") ?: return 0.0
        val hl = poseResult.getKptPosByName("left_hip") ?: return 0.0
        val hr = poseResult.getKptPosByName("right_hip") ?: return 0.0
        if (sl.size < 3 || sr.size < 3 || hl.size < 3 || hr.size < 3) return 0.0

        val shoulderVec = listOf(listOf(sl[0], sl[2]), listOf(sr[0], sr[2]))
        val hipVec = listOf(listOf(hl[0], hl[2]), listOf(hr[0], hr[2]))
        return Calculator.getAngleBetweenTwoLinesPosition(shoulderVec, hipVec)
    }

    // ===== Python: get_pose_hip_knee_staggered_angle_xz =====
    fun getPoseHipKneeStaggeredAngleXZ(): Double {
        val hl = poseResult.getKptPosByName("left_hip") ?: return 0.0
        val hr = poseResult.getKptPosByName("right_hip") ?: return 0.0
        val kl = poseResult.getKptPosByName("left_knee") ?: return 0.0
        val kr = poseResult.getKptPosByName("right_knee") ?: return 0.0
        if (hl.size < 3 || hr.size < 3 || kl.size < 3 || kr.size < 3) return 0.0

        val hipVec = listOf(listOf(hl[0], hl[2]), listOf(hr[0], hr[2]))
        val kneeVec = listOf(listOf(kl[0], kl[2]), listOf(kr[0], kr[2]))
        return Calculator.getAngleBetweenTwoLinesPosition(hipVec, kneeVec)
    }

    // ===== Python: get_two_hands_center_to_gravity_dist =====
    fun getTwoHandsCenterToGravityDist(): Double {
        val hand = getCenterPositionBy2Hand()
        val gravity = getBodyGravityPosition()
        if (hand.size < 3 || gravity.size < 3) return 0.0
        return Calculator.getDistBetweenPoints(hand, gravity)
    }

    // ===== Python: check_if_trunk_is_twisted_or_lateral_inclination =====
    fun checkIfTrunkIsTwistedOrLateralInclination(): Boolean {
        return checkIfTrunkIsTwisted() || checkIfTrunkIsLateralInclination()
    }

    // ===== Python: check_if_trunk_is_twisted (TWISTED_ANGLE=30, shoulder-hip OR hip-knee) =====
    fun checkIfTrunkIsTwisted(): Boolean {
        val TWISTED_ANGLE = 30.0
        val a1 = getPoseShoulderHipStaggeredAngleXZ()
        val a2 = getPoseHipKneeStaggeredAngleXZ()
        Log.d("ResultAnalyzer", "Trunk twisted angles: shoulder-hip=$a1, hip-knee=$a2")
        return (a1 > TWISTED_ANGLE) || (a2 > TWISTED_ANGLE)
    }

    // ===== Python: check_if_trunk_is_lateral_inclination (HEIGHT_DIFF=0.6) =====
    fun checkIfTrunkIsLateralInclination(): Boolean {
        val HEIGHT_DIFF = 0.6
        val sl = poseResult.getKptPosByName("left_shoulder") ?: return false
        val sr = poseResult.getKptPosByName("right_shoulder") ?: return false
        if (sl.size < 3 || sr.size < 3) return false

        val shoulderDiff = abs(sl[1] - sr[1]) // Python np.linalg.norm(scalar) == abs
        Log.d("ResultAnalyzer", "Lateral inclination shoulderDiff=$shoulderDiff (threshold=$HEIGHT_DIFF)")
        return shoulderDiff > HEIGHT_DIFF
    }

    // ===== Python: check_if_hands_at_a_distance (DIST=0.4, wrist-to-body-gravity 3D norm) =====
    fun checkIfHandsAtADistance(): Boolean {
        val DIST = 0.4
        val gravity = getBodyGravityPosition()
        val wl = poseResult.getKptPosByName("left_wrist") ?: return false
        val wr = poseResult.getKptPosByName("right_wrist") ?: return false
        if (gravity.size < 3 || wl.size < 3 || wr.size < 3) return false

        val leftDist = l2Norm3(wl, gravity)
        val rightDist = l2Norm3(wr, gravity)

        Log.d("ResultAnalyzer", "Hands at distance: left=$leftDist, right=$rightDist, threshold=$DIST")
        return (leftDist > DIST) || (rightDist > DIST)
    }

    // ===== Python: check_if_arms_raised =====
    fun checkIfArmsRaised(): Boolean {
        val RAISED_ANGLE = 60.0

        fun isRaised(side: String): Boolean {
            val shoulderAngle = getJointAngleByName("${side}_shoulder")
            val shoulderY = poseResult.getKptPosByName("${side}_shoulder")?.getOrNull(1) ?: return false
            val elbowY = poseResult.getKptPosByName("${side}_elbow")?.getOrNull(1) ?: return false
            val wristY = poseResult.getKptPosByName("${side}_wrist")?.getOrNull(1) ?: return false

            val shoulderYInv = -shoulderY
            val elbowYInv = -elbowY
            val wristYInv = -wristY

            val ok = (shoulderAngle > RAISED_ANGLE) && (shoulderYInv > wristYInv) && (wristYInv > elbowYInv)
            Log.d("ResultAnalyzer", "ArmsRaised($side): angle=$shoulderAngle, yInv(S,W,E)=($shoulderYInv,$wristYInv,$elbowYInv) -> $ok")
            return ok
        }

        return isRaised("left") || isRaised("right")
    }

    // ===== Python: check_if_hands_above_shoulder =====
    fun checkIfHandsAboveShoulder(): Boolean {
        val lw = poseResult.getKptPosByName("left_wrist")?.getOrNull(1) ?: return false
        val ls = poseResult.getKptPosByName("left_shoulder")?.getOrNull(1) ?: return false
        val rw = poseResult.getKptPosByName("right_wrist")?.getOrNull(1) ?: return false
        val rs = poseResult.getKptPosByName("right_shoulder")?.getOrNull(1) ?: return false

        val lwInv = -lw
        val lsInv = -ls
        val rwInv = -rw
        val rsInv = -rs

        val ok = (lwInv > lsInv) || (rwInv > rsInv)
        Log.d("ResultAnalyzer", "HandsAboveShoulder: left($lwInv>$lsInv) right($rwInv>$rsInv) -> $ok")
        return ok
    }

    private fun l2Norm3(a: List<Double>, b: List<Double>): Double {
        val dx = (a[0] - b[0])
        val dy = (a[1] - b[1])
        val dz = (a[2] - b[2])
        return sqrt(dx.pow(2) + dy.pow(2) + dz.pow(2))
    }
}
