package com.example.ncyu_kim.mediapipelib

data class LineConnections(
    val leftKpt: List<List<String>> = emptyList(),
    val rightKpt: List<List<String>> = emptyList(),
    val centerKpt: List<List<String>> = emptyList()
) {
    val fullKpt: List<List<String>> = leftKpt + rightKpt + centerKpt
}

val blazepose_line = LineConnections(
    leftKpt = listOf(
        listOf("nose", "left_eye"),
        listOf("left_eye", "left_ear"),
        listOf("left_shoulder", "left_elbow"),
        listOf("left_elbow", "left_wrist"),
        listOf("left_wrist", "left_pinky"),
        listOf("left_wrist", "left_index"),
        listOf("left_wrist", "left_thumb"),
        listOf("left_pinky", "left_index"),
        listOf("left_shoulder", "left_hip"),
        listOf("left_hip", "left_knee"),
        listOf("left_knee", "left_ankle"),
        listOf("left_ankle", "left_heel"),
        listOf("left_ankle", "left_foot_index"),
        listOf("left_heel", "left_foot_index")
    ),
    rightKpt = listOf(
        listOf("nose", "right_eye"),
        listOf("right_eye", "right_ear"),
        listOf("right_shoulder", "right_elbow"),
        listOf("right_elbow", "right_wrist"),
        listOf("right_wrist", "right_pinky"),
        listOf("right_wrist", "right_index"),
        listOf("right_wrist", "right_thumb"),
        listOf("right_pinky", "right_index"),
        listOf("right_shoulder", "right_hip"),
        listOf("right_hip", "right_knee"),
        listOf("right_knee", "right_ankle"),
        listOf("right_ankle", "right_heel"),
        listOf("right_ankle", "right_foot_index"),
        listOf("right_heel", "right_foot_index")
    ),
    centerKpt = listOf(
        listOf("mouth_left", "mouth_right"),
        listOf("left_shoulder", "right_shoulder"),
        listOf("left_hip", "right_hip")
    )
)

val KPT_LIST = listOf(
    "nose", "left_eye_inner", "left_eye", "left_eye_outer", "right_eye_inner",
    "right_eye", "right_eye_outer", "left_ear", "right_ear", "mouth_left",
    "mouth_right", "left_shoulder", "right_shoulder", "left_elbow", "right_elbow",
    "left_wrist", "right_wrist", "left_pinky", "right_pinky", "left_index",
    "right_index", "left_thumb", "right_thumb", "left_hip", "right_hip",
    "left_knee", "right_knee", "left_ankle", "right_ankle", "left_heel",
    "right_heel", "left_foot_index", "right_foot_index"
)

val JOINT_NAME_DICT = mapOf(
    "left_shoulder" to listOf("left_elbow", "left_hip"),
    "right_shoulder" to listOf("right_elbow", "right_hip"),
    "left_hip" to listOf("left_shoulder", "left_knee"),
    "right_hip" to listOf("right_shoulder", "right_knee"),
    "left_knee" to listOf("left_hip", "left_ankle"),
    "right_knee" to listOf("right_hip", "right_ankle")
)

val JOINT_IDX_DICT = mapOf(
    11 to listOf(13, 23),
    12 to listOf(14, 24),
    23 to listOf(11, 25),
    24 to listOf(12, 26),
    25 to listOf(23, 27),
    26 to listOf(24, 28)
)
