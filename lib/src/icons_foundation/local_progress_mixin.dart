mixin LocalProgress {
  double get progress;

  double computeLocalProgress(
    double start,
    double duration,
  ) {
    assert(start >= 0.0 && start <= 1.0);
    assert(duration >= 0.0 && duration <= 1.0);
    assert(start + duration <= 1.0);

    final localProgress =
        progress >= start ? (progress - start) * (1.0 / duration) : 0.0;

    return localProgress < 1.0 ? localProgress : 1.0;
  }
}
