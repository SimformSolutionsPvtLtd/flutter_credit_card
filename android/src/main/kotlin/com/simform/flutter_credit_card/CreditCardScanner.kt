package com.simform.flutter_credit_card

import android.Manifest
import android.app.Activity
import androidx.appcompat.app.AppCompatActivity
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

private const val CAMERA_REQUEST_CODE = 7762

class CreditCardScanner : PluginRegistry.RequestPermissionsResultListener {
    private var permissions = arrayOf(Manifest.permission.CAMERA)

    fun checkCameraPermission(result: MethodChannel.Result, activity: Activity?) {
        if (!isPermissionGranted(activity)) {
            activity?.let {
                ActivityCompat.requestPermissions(
                    it, permissions,
                    CAMERA_REQUEST_CODE,
                )
            }
        } else {
            result.success(true)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        return if (requestCode == CAMERA_REQUEST_CODE) {
            grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
        } else {
            false
        }
    }

    private fun isPermissionGranted(activity: Activity?): Boolean {
        val result =
            ActivityCompat.checkSelfPermission(activity!!, permissions[0])
        return result == PackageManager.PERMISSION_GRANTED
    }
}