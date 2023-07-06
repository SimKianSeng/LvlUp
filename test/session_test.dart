import 'package:flutter_test/flutter_test.dart';
import 'package:lvlup/models/session.dart';
import 'package:time_planner/time_planner.dart';

void main() {
  group("Testing breakDuration functionality", () {
    test("Session of 30minutes duration", () {
      Session session = Session(dateTime: TimePlannerDateTime(day: 0, hour: 0, minutes: 00));

      int breakDuration = session.breakDuration();

      expect(5, breakDuration);
    });

    test("Session of 1h duration", () {
      Session session = Session(minutesDuration: 60, dateTime: TimePlannerDateTime(day: 0, hour: 0, minutes: 00));

      int breakDuration = session.breakDuration();

      expect(10, breakDuration);
    });

  });

  group("Testing breakRemaining functionality", () {
    test("Late by 0 minutes for a 30minutes session", () {
      Session session = Session(dateTime: TimePlannerDateTime(day: 0, hour: 0, minutes: 00));

      Duration lateByMinutes = const Duration(); // Duration of 0 seconds

      Duration breakRemainingMinutes = session.breakRemaining(lateByMinutes);

      expect(const Duration(minutes: 5), breakRemainingMinutes);
    });

    test("Late by 5 minutes for a 30minutes session", () {
      Session session = Session(dateTime: TimePlannerDateTime(day: 0, hour: 0, minutes: 00));

      Duration lateByMinutes = const Duration(minutes: 5); // Duration of 0 seconds

      Duration breakRemainingMinutes = session.breakRemaining(lateByMinutes);

      expect(const Duration(minutes: 0), breakRemainingMinutes);
    });

    test("Late by 2 minutes for a 30minutes session", () {
      Session session = Session(dateTime: TimePlannerDateTime(day: 0, hour: 0, minutes: 00));

      Duration lateByMinutes = const Duration(minutes: 2); // Duration of 0 seconds

      Duration breakRemainingMinutes = session.breakRemaining(lateByMinutes);

      expect(const Duration(minutes: 5 - 2), breakRemainingMinutes);
    });

    test("Late by 15 minutes for a 30minutes session", () {
      Session session = Session(dateTime: TimePlannerDateTime(day: 0, hour: 0, minutes: 00));

      Duration lateByMinutes = const Duration(minutes: 15); // Duration of 0 seconds

      Duration breakRemainingMinutes = session.breakRemaining(lateByMinutes);

      expect(const Duration(minutes: 5 - 15), breakRemainingMinutes);
    });
  });
}