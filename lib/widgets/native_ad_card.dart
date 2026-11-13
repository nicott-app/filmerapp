import 'package:filmer/services/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdCard extends StatefulWidget {
  const NativeAdCard({super.key});

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: 'listTile', // Ensure this matches Android setup or remove if custom
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Native Ad failed to load: $error');
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.black,
        cornerRadius: 20.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Colors.amber,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
           textColor: Colors.white,
           backgroundColor: Colors.transparent,
           style: NativeTemplateFontStyle.bold,
           size: 16.0,
        ),
         secondaryTextStyle: NativeTemplateTextStyle(
           textColor: Colors.grey,
           backgroundColor: Colors.transparent,
           style: NativeTemplateFontStyle.normal,
           size: 14.0,
        ),
      ),
    );

    _nativeAd!.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded) {
       // Placeholder
       return Container(
         decoration: BoxDecoration(
           color: Colors.grey[900],
           borderRadius: BorderRadius.circular(24),
         ),
         child: const Center(
           child: Text("Cargando Publicidad...", style: TextStyle(color: Colors.white54)),
         ),
       );
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
             // Ad Content
             AdWidget(ad: _nativeAd!),
             
             // "Ad" Badge
             Positioned(
               top: 16,
               right: 16,
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                 decoration: BoxDecoration(
                   color: Colors.amber,
                   borderRadius: BorderRadius.circular(4),
                 ),
                 child: const Text(
                   "AD",
                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                 ),
               ),
             ),
          ],
        ),
      ),
    );
  }
}

