package com.example.ncyu_kim.mediapipelib

import kotlin.math.acos
import kotlin.math.sqrt
import kotlin.math.max
import kotlin.math.min
import kotlin.math.pow
import android.util.Log

object Calculator {
    fun getAngleBy3Points(pos1: List<Double>, pos2: List<Double>, centerPos: List<Double>): Double {
        if (pos1.size < 2 || pos2.size < 2 || centerPos.size < 2) {
            Log.w("Calculator", "Invalid input for getAngleBy3Points: pos1=$pos1, pos2=$pos2, centerPos=$centerPos")
            return 0.0
        }
        val a = distance(pos1, pos2)
        val b = distance(pos1, centerPos)
        val c = distance(pos2, centerPos)
        val denom = 2.0 * b * c
        if (denom <= 1e-12) {
            Log.w("Calculator", "Denominator too small: denom=$denom, a=$a, b=$b, c=$c")
            return 0.0
        }
        var cosVal = (b * b + c * c - a * a) / denom
        cosVal = clamp(cosVal, -1.0, 1.0)
        val angle = Math.toDegrees(acos(cosVal))
        Log.d("Calculator", "getAngleBy3Points: a=$a, b=$b, c=$c, cosVal=$cosVal, angle=$angle")
        return if (angle.isNaN() || angle.isInfinite()) 0.0 else angle
    }

    fun getAngleBetweenTwoLinesPosition(line1: List<List<Double>>, line2: List<List<Double>>): Double {
        if (line1.size < 2 || line2.size < 2) {
            Log.w("Calculator", "Invalid lines: line1=$line1, line2=$line2")
            return 0.0
        }
        val pos1a = line1[0]
        val pos1b = line1[1]
        val pos2a = line2[0]
        val pos2b = line2[1]
        val vec1 = pos1a.zip(pos1b) { a, b -> a - b }
        val vec2 = pos2a.zip(pos2b) { a, b -> a - b }
        val norm1 = norm(vec1)
        val norm2 = norm(vec2)
        if (norm1 <= 1e-12 || norm2 <= 1e-12) {
            Log.w("Calculator", "Norm too small: norm1=$norm1, norm2=$norm2")
            return 0.0
        }
        val dotProduct = dot(vec1, vec2)
        var cosVal = dotProduct / (norm1 * norm2)
        cosVal = clamp(cosVal, -1.0, 1.0)
        val angle = Math.toDegrees(acos(cosVal))
        Log.d("Calculator", "getAngleBetweenTwoLinesPosition: vec1=$vec1, vec2=$vec2, dot=$dotProduct, cosVal=$cosVal, angle=$angle")
        return if (angle.isNaN() || angle.isInfinite()) 0.0 else angle
    }

    fun getDistBetweenPoints(vararg pointList: List<Double>): Double {
        var dist = 0.0
        if (pointList.size > 1) {
            var pt1 = pointList[0]
            for (pt2 in pointList.drop(1)) {
                dist += distance(pt1, pt2)
                pt1 = pt2
            }
        }
        Log.d("Calculator", "getDistBetweenPoints: points=${pointList.toList()}, dist=$dist")
        return dist
    }

    fun getTriangleGravityPosition(pos1: List<Double>, pos2: List<Double>, pos3: List<Double>): List<Double> {
        val size = minOf(pos1.size, pos2.size, pos3.size)
        val result = (0 until size).map { i ->
            ((pos1.getOrNull(i) ?: 0.0) +
                    (pos2.getOrNull(i) ?: 0.0) +
                    (pos3.getOrNull(i) ?: 0.0)) / 3.0
        }
        Log.d("Calculator", "getTriangleGravityPosition: pos1=$pos1, pos2=$pos2, pos3=$pos3, result=$result")
        return result
    }

    private fun distance(p1: List<Double>, p2: List<Double>): Double {
        val size = minOf(p1.size, p2.size)
        val result = (0 until size).fold(0.0) { acc, i ->
            val d = p1[i] - p2[i]
            acc + (d * d)
        }.let { sqrt(it) }
        Log.d("Calculator", "distance: p1=$p1, p2=$p2, result=$result")
        return result
    }

    private fun norm(vec: List<Double>): Double {
        val result = vec.fold(0.0) { acc, v -> acc + (v * v) }.let { sqrt(it) }
        Log.d("Calculator", "norm: vec=$vec, result=$result")
        return result
    }

    private fun dot(v1: List<Double>, v2: List<Double>): Double {
        val size = minOf(v1.size, v2.size)
        val result = (0 until size).fold(0.0) { acc, i -> acc + (v1[i] * v2[i]) }
        Log.d("Calculator", "dot: v1=$v1, v2=$v2, result=$result")
        return result
    }

    private fun clamp(v: Double, lo: Double, hi: Double): Double {
        return max(lo, min(hi, v))
    }
}
