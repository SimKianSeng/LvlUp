import 'dart:math';

///Generator is a singleton class that takes in the input for the schedule consisting:
///modules (ranked), intensity and free sessions.
///Using these inputs, generator will utilise 'weighted random selection' algorithm
///and distribute the modules across the free sessions based on level of intensity
class Generator {

  static final Generator _instance = Generator._internal();
  static const FREEPERIOD = 'free';

  List<String> modules = [];
  int intensity = 5;
  late List<DateTime> sessions;
  List<String> allocations = [];

  factory Generator() {
    return _instance;
  }

  Generator._internal();

  bool alreadyInput(String module) {
    return modules.contains(module);
  }

  void updateModule(String module, int rank) {
    if (modules.length < rank) {
      modules.insert(rank - 1, module);
    } else if (modules.elementAt(rank - 1) != module) {
      modules.removeAt(rank - 1);
      modules.insert(rank - 1, module);
    }
  }

  bool isAdded(int rank) {
    bool moduleAdded = modules.length != rank;
    
    return moduleAdded;
  }

  // void addSessions(List<DateTime> sessions) {
  //   this.sessions = sessions;
  // }

  void updateIntensity(int intensity) {
    this.intensity = intensity;
  }

  List<String> generateSchedule() {
    int numberOfFreeSessions = sessions.length;

    //Reset allocations for each generateSchedule call
    allocations = [];


    while (numberOfFreeSessions != 0) {
      String module = selectModule();

      allocations.add(module);

      numberOfFreeSessions -= 1;
    }

    return allocations;
  }

  
  String selectModule() {
    //Save the need to compute everytime if there are no modules or zero intensity
    if (modules.isEmpty || intensity == 0) {
      return 'free';
    }

    if (modules.contains(FREEPERIOD)) {
      modules.remove(FREEPERIOD);
    }

    int moduleWeightage = ((modules.length + 1) * modules.length) * 5; // (/ 2 * 10)
    int totalWeightage = 0; // will increment as we iterate through

    List<int> prefixSum = [];


    for (int i = 0; i < modules.length; i++) {
      int rank = modules.length - i;
      rank *= 10;
      totalWeightage += rank;
      prefixSum.add(totalWeightage);
    }

    if (intensity != 10) {
      int freePeriodWeightage = (moduleWeightage * (10 - intensity)) ~/ intensity;
      modules.add(FREEPERIOD);
      prefixSum.add(freePeriodWeightage + moduleWeightage);
    }

    int target = 1 + Random().nextInt(prefixSum.last);


    //Binary search to find smallest index corresponding to prefix sum greater than target
    int start = 0;
    int end = prefixSum.length - 1;

    while(start < end) {
      int mid = (start + end) ~/ 2;
      if (prefixSum[mid] < target) {
        start = mid + 1;
      } else if (prefixSum[mid] > target) {
        end = mid;
      } else {
        start = mid;
        break;
      }
    }


    String module = modules[start];
    return module;
  }
  
}