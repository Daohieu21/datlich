import 'package:Appointment/gen/assets.gen.dart';

extension CurrentWeatherExt on int? {

  String get toWeatherDes {
    Map<int, String> weatherDescriptions = {
      0: "Clear sky",
      1: "Mainly clear",
      2: "Partly cloudy",
      3: "Cloudy",
      4: "Overcast",
      5: "Fog",
      10: "Mist",
      20: "Drizzle",
      30: "Rain",
      40: "Snow",
      50: "Rain showers",
      60: "Snow showers",
      70: "Thunderstorms",
      80: "Freezing rain",
      90: "Hail",
      100: "Rain and snow",
      110: "Dust or sandstorm",
      120: "Fog or ice fog",
      130: "Smoke or volcanic ash",
      140: "Haze",
      //-1: "Không xác định",
    };
    Map<int, String> weatherImages = {
      0: Assets.images.clearSky.path,
      1: Assets.images.mainlyClear.path,
      2: Assets.images.partlyCloudy.path,
      3: Assets.images.cloudy.path,
      4: Assets.images.overcast.path,
      5: Assets.images.fog.path,
      10: Assets.images.mist.path,
      20: Assets.images.drizzle.path,
      30: Assets.images.rain.path,
      40: Assets.images.snow.path,
      50: Assets.images.rainShowers.path,
      60: Assets.images.snowShowers.path,
      70: Assets.images.thunderstorms.path,
      80: Assets.images.freezingRain.path,
      90: Assets.images.hail.path,
      100: Assets.images.rainAndSnow.path,
      110: Assets.images.dustOrSandstorm.path,
      120: Assets.images.fogOrIceFog.path,
      130: Assets.images.smokeOrVolcanicAsh.path,
      140: Assets.images.haze.path,
      //-1:  Assets.images.haze.path,
    };

    // Kiểm tra nếu mã thời tiết có trong map weatherDescriptions
    if (weatherDescriptions.containsKey(this)) {
      // Lấy tên tương ứng từ map
      String description = weatherDescriptions[this]!;
      // Lấy đường dẫn ảnh từ map
      String imagePath = weatherImages[this]!;
      // Trả về chuỗi mô tả và đường dẫn ảnh
      return "$description|$imagePath";
    } else {
      return "Không xác định";
    }
  }
}
