package com.jewel.flutter_onlie_shop;

//import android.content.Context;
//import android.content.pm.PackageInfo;
//import android.content.pm.PackageManager;
//import android.content.pm.Signature;
//import android.os.Bundle;
//import android.util.Base64;
//import android.util.Log;
//
//import androidx.annotation.Nullable;
//
//import java.security.MessageDigest;
//import java.security.NoSuchAlgorithmException;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
//    @Override
//    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
////        getHashkey();
//    }
//
//    public void getHashkey() {
//        try {
//            PackageInfo info = getPackageManager().getPackageInfo(getApplicationContext().getPackageName(), PackageManager.GET_SIGNATURES);
//            for (Signature signature : info.signatures) {
//                MessageDigest md = MessageDigest.getInstance("SHA");
//                md.update(signature.toByteArray());
//
//                Log.e("Base64", Base64.encodeToString(md.digest(), Base64.NO_WRAP));
//            }
//        } catch (PackageManager.NameNotFoundException e) {
//            Log.e("Name not found", e.getMessage(), e);
//
//        } catch (NoSuchAlgorithmException e) {
//            Log.e("Error", e.getMessage(), e);
//        }
//    }
}
