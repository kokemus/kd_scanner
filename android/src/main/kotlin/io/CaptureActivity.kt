package io.github.kokemus.kd_scanner

import android.util.Log

class CaptureActivity: com.journeyapps.barcodescanner.CaptureActivity() {
  override fun onBackPressed() {
    finish()
  }
}