class SessionManager {
  String getCurrentSession() {
    int hour = DateTime.now().hour;
    if(hour >= 0 && hour < 9) return "Asia";
    if(hour >= 9 && hour < 17) return "London";
    if(hour >= 17 && hour < 24) return "NY";
    return "Unknown";
  }

  double sessionAggressionMultiplier() {
    String session = getCurrentSession();
    switch(session) {
      case "Asia": return 0.7;
      case "London": return 1.0;
      case "NY": return 1.2;
      default: return 1.0;
    }
  }
}
