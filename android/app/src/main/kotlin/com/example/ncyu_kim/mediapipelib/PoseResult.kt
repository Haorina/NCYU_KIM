package com.example.ncyu_kim.mediapipelib

import android.util.Log
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarkerResult
import com.google.mediapipe.tasks.components.containers.Landmark
import com.google.mediapipe.tasks.components.containers.NormalizedLandmark

class PoseResult(private val result: PoseLandmarkerResult) {
    fun getKptPosByIndex(idx: Int, get3d: Boolean = false): List<Double> {
        val landmarks = if (get3d) result.worldLandmarks() else result.landmarks()
        if (landmarks.isEmpty() || landmarks[0].size <= idx) {
            Log.w("PoseResult", "Invalid landmark index $idx, get3d=$get3d")
            return emptyList()
        }
        val kpt = landmarks[0][idx]
        val pos = if (!get3d) {
            val lmk = kpt as NormalizedLandmark
            listOf(lmk.x().toDouble(), lmk.y().toDouble())
        } else {
            val lmk = kpt as Landmark
            listOf(lmk.x().toDouble(), lmk.y().toDouble(), lmk.z().toDouble())
        }
        Log.d("PoseResult", "getKptPosByIndex: idx=$idx, get3d=$get3d, pos=$pos")
        return pos
    }

    fun getKptPosByName(kptName: String, get3d: Boolean = false): List<Double>? {
        val idx = KPT_LIST.indexOf(kptName)
        if (idx < 0) {
            Log.w("PoseResult", "Unknown keypoint name: $kptName")
            return null
        }
        val pos = getKptPosByIndex(idx, get3d)
        return if (pos.isEmpty()) {
            Log.w("PoseResult", "Empty pos for kptName=$kptName, get3d=$get3d")
            null
        } else pos
    }

    fun getAllKptPositions(get3d: Boolean = false): List<List<Double>> {
        val landmarks = if (get3d) result.worldLandmarks() else result.landmarks()
        if (landmarks.isEmpty()) {
            Log.w("PoseResult", "No landmarks available in PoseLandmarkerResult")
            return emptyList()
        }
        return landmarks[0].mapIndexed { idx, kpt ->
            val pos = if (!get3d) {
                val lmk = kpt as NormalizedLandmark
                listOf(lmk.x().toDouble(), lmk.y().toDouble())
            } else {
                val lmk = kpt as Landmark
                listOf(lmk.x().toDouble(), lmk.y().toDouble(), lmk.z().toDouble())
            }
            Log.d("PoseResult", "getAllKptPositions: idx=$idx, get3d=$get3d, pos=$pos")
            pos
        }
    }
}
