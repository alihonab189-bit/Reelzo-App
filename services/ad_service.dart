import '../data/ad_data.dart';
import '../models/ad_model.dart';

class AdService {
  List<AdModel> getAds() {
    return ads; 
  }

  // Logic to get a random ad by ID
  AdModel getRandomAd() {
    return (ads..shuffle()).first;
  }
}