package com.funnyworld.game;
import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebChromeClient;
public class MainActivity extends Activity {
 private WebView web;
 @Override public void onCreate(Bundle state){super.onCreate(state);getWindow().getDecorView().setSystemUiVisibility(5894);getWindow().addFlags(128);web=new WebView(this);web.setBackgroundColor(0xff06090c);web.getSettings().setJavaScriptEnabled(true);web.getSettings().setDomStorageEnabled(true);web.getSettings().setAllowFileAccess(true);web.getSettings().setMediaPlaybackRequiresUserGesture(false);web.setWebViewClient(new WebViewClient());web.setWebChromeClient(new WebChromeClient());setContentView(web);web.loadUrl("file:///android_asset/index.html");}
 @Override protected void onPause(){super.onPause();web.evaluateJavascript("if(typeof pause==='function' && active && !overlay) pause();",null);web.onPause();web.pauseTimers();}
 @Override protected void onResume(){super.onResume();if(web!=null){web.onResume();web.resumeTimers();}}
 @Override public void onBackPressed(){web.evaluateJavascript("if(active){if(overlay){document.getElementById('map').classList.add('hidden');closeNote();}else pause();}",null);}
}
