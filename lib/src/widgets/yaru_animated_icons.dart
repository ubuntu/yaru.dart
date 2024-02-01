import 'package:animated_vector/animated_vector.dart';
import 'package:animated_vector_annotations/animated_vector_annotations.dart';
import 'package:flutter/widgets.dart';

part 'yaru_animated_icons.g.dart';

// ignore_for_file: constant_identifier_names
abstract final class YaruAnimatedIcons {
  @ShapeShifterAsset('assets/shapeshifter/compass.shapeshifter')
  static const compass = _$compass;

  @ShapeShifterAsset('assets/shapeshifter/compass_filled.shapeshifter')
  static const compass_filled = _$compass_filled;

  @ShapeShifterAsset('assets/shapeshifter/heart.shapeshifter')
  static const heart = _$heart;

  @ShapeShifterAsset('assets/shapeshifter/heart_filled.shapeshifter')
  static const heart_filled = _$heart_filled;

  @ShapeShifterAsset('assets/shapeshifter/no_network.shapeshifter')
  static const no_network = _$no_network;

  @ShapeShifterAsset('assets/shapeshifter/ok.shapeshifter')
  static const ok = _$ok;

  @ShapeShifterAsset('assets/shapeshifter/ok_filled.shapeshifter')
  static const ok_filled = _$ok_filled;

  @ShapeShifterAsset('assets/shapeshifter/star.shapeshifter')
  static const star = _$star;

  @ShapeShifterAsset('assets/shapeshifter/star_filled.shapeshifter')
  static const star_filled = _$star_filled;

  @ShapeShifterAsset('assets/shapeshifter/star_half_filled.shapeshifter')
  static const star_half_filled = _$star_half_filled;

  @ShapeShifterAsset('assets/shapeshifter/thumb_up.shapeshifter')
  static const thumb_up = _$thumb_up;

  @ShapeShifterAsset('assets/shapeshifter/thumb_up_filled.shapeshifter')
  static const thumb_up_filled = _$thumb_up_filled;

  static const all = {
    'compass': compass,
    'compass_filled': compass_filled,
    'heart': heart,
    'heart_filled': heart_filled,
    'no_network': no_network,
    'ok': ok,
    'ok_filled': ok_filled,
    'star': star,
    'star_filled': star_filled,
    'star_half_filled': star_half_filled,
    'thumb_up': thumb_up,
    'thumb_up_filled': thumb_up_filled,
  };
}
