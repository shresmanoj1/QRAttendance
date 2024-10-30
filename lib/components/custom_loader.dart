import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';


customLoadStart() {
  return  OverlayLoadingProgress.start(
    widget: Container(
      height: 100,
      width: 100,
      color: Colors.black38,
      child: const Center(
        child: CupertinoActivityIndicator(color: Colors.white),
      ),
    ),
  );
}

customLoadStop() {
  return  OverlayLoadingProgress.stop();
}