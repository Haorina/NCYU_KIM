package com.example.ncyu_kim.mediapipelib

import android.util.Log
import com.google.mediapipe.tasks.components.containers.Landmark
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarkerResult

class PoseResult(private val result: PoseLandmarkerResult) {

    /**
     * Python 版本只用 pose_world_landmarks -> 等同 MediaPipe Android 的 worldLandmarks()
     * 所以這裡預設回傳 3D world 座標。
     */
    fun getKptPosByName(kptName: String): List<Double>? {
        val idx = KPT_LIST.indexOf(kptName)
        if (idx < 0) {
            Log.w("PoseResult", "Unknown keypoint name: $kptName")
            return null
        }
        return getKptPosByIndex(idx)
    }

    fun getKptPosByIndex(idx: Int): List<Double> {
        val landmarks = result.worldLandmarks()
        if (landmarks.isEmpty() || landmarks[0].size <= idx) {
            Log.w("PoseResult", "Invalid landmark index $idx (worldLandmarks)")
            return emptyList()
        }
        val kpt = landmarks[0][idx] as Landmark
        return listOf(kpt.x().toDouble(), kpt.y().toDouble(), kpt.z().toDouble())
    }

    fun getAllKptPositions(): List<List<Double>> {
        val landmarks = result.worldLandmarks()
        if (landmarks.isEmpty()) {
            Log.w("PoseResult", "No world landmarks available in PoseLandmarkerResult")
            return emptyList()
        }
        return landmarks[0].mapIndexed { idx, kpt ->
            val lmk = kpt as Landmark
            listOf(lmk.x().toDouble(), lmk.y().toDouble(), lmk.z().toDouble())
        }
    }
}
