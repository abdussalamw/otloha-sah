import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/models/ads/ads_model.dart';
import 'package:otloha_sah_flutter/data_source/remote/ads_service.dart';
import 'package:otloha_sah_flutter/modules/home/presentation/widget/ads_item_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/indicator.dart';

class AdsListing extends StatefulWidget {
  @override
  _AdsListingState createState() => _AdsListingState();
}

class _AdsListingState extends State<AdsListing> {
  late PageController _pageController;
  int _position = 0;
  List<AdsModel>? _adsData;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchAdsData();
  }

  Future<void> _fetchAdsData() async {
    // Replace this with your actual API call
    _adsData = await AdsApi().getAds();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _position = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: _adsData != null
          ? Stack(
              children: [
                PageView.builder(
                  itemCount: _adsData!.length,
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    return AdsItemView(
                      image: _adsData![index].image,
                      action: () {
                        if (_adsData![index].url != null) {
                          launchUrl(Uri.parse(_adsData![index].url!));
                        }
                      },
                    );
                  },
                ),
                Align(
                  alignment: const Alignment(0, 0.8),
                  child: Indicator(
                    size: _adsData!.length,
                    current: _position,
                  ),
                ),
              ],
            )
          : Container(
              color: Colors.transparent,
            ),
    );
  }
}
