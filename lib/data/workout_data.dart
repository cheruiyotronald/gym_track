import 'package:flutter/cupertino.dart';
import 'package:gym_track_app/data/hive_database.dart';
import 'package:gym_track_app/datetime/data_time.dart';
import 'package:gym_track_app/pages/model/exercise.dart';
import '../pages/model/workouts.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

/*

WORKOUT DATA STRUCTURE

-This overall list contains all the workouts
-Each workout has a name, and list of exercises

*/

  List<Workout> workoutList = [
    //default workout
    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(name: "Bicep curl", weight: "10", reps: "10", sets: "3"),
      ],
    ),
    Workout(
      name: "Lower Body",
      exercises: [
        Exercise(name: "squats", weight: "10", reps: "10", sets: "3"),
      ],
    ),
  ];

  //if there are workouts already in a database, then get that workout list,
  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    }

    //otherwise use default workout list
    else {
      db.saveToDatabase(workoutList);
    }
    loadHeatMap(); 
  }

  //get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //get length of a given workout
  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  //add a workout
  void addWorkout(String name) {
    //add a new workout with a blank list of exercises
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //add an exercise to a workout
  void addExercise(
    String workoutName,
    String exerciseName,
    String weight,
    String reps,
    String sets,
  ) {
    //find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets),
    );

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    //find relevant workout and relevant exercise in thet workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    //check off boolean to show user completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    print('tapped');

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
    //load heat map
    loadHeatMap();
  }

  //return relevant workout, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((Workout) => Workout.name == workoutName);

    return relevantWorkout;
  }

  //return relevant exercise object, given a workout name *exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    //find relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    //then find the relevant exercise in the workout
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((Exercise) => Exercise.name == exerciseName);

    return relevantExercise;
  }

  // get start date
  String getStartDate() {
    return db.getStartDate();
  }
  /*

  HEAT MAP

  */
  Map<DateTime, int > heatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    //count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //go from start day to today, and add each completion status to the datasets
    //"COMPLETION_STATUS_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1;) {
      String yyyymmdd = convertDateTimeToYYYYMMDD(
        startDate.add(
          Duration(days: i),
        ),
      );

      //completion status = 0 or 1
      int completionStatus = db.getCompletionStatus(yyyymmdd);

      //year
      int year = startDate.add(Duration(days: i)).year;

      //month
      int month = startDate.add(Duration(days: i)).month;

      //day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };

      //add to the heat map dataset
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
