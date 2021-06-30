/// A class that represent an analytics event to track
/// You can either use this direct or implement it in your custom events
class AnalyticsEvent {
  const AnalyticsEvent({
    required this.eventName,
    this.parameters,
  });

  /// Analytics event name
  final String eventName;

  /// Analytics event properties
  final Map<String, dynamic>? parameters;
}

/// Interface that define an analytics tracker
abstract class Tracker {
  void logPageView(String name);
  void logEvent(AnalyticsEvent event);
  void setUserProperty(String key, Object any);
  void setUserId(String id);
}

/// A tracker that allow you to use different services at once
class MultipleTracker implements Tracker {
  const MultipleTracker(this.trackers);

  final Iterable<Tracker> trackers;

  @override
  void logPageView(String name) {
    try {
      for (final tracker in trackers) {
        tracker.logPageView(name);
      }
    } on Exception {
      //
    }
  }

  @override
  void logEvent(AnalyticsEvent event) {
    try {
      for (final tracker in trackers) {
        tracker.logEvent(event);
      }
    } on Exception {
      //
    }
  }

  @override
  void setUserProperty(String key, Object any) {
    try {
      for (final tracker in trackers) {
        tracker.setUserProperty(key, any);
      }
    } on Exception {
      //
    }
  }

  @override
  void setUserId(String id) {
    try {
      for (final tracker in trackers) {
        tracker.setUserId(id);
      }
    } on Exception {
      //
    }
  }
}
