import 'package:gym_track_app/datetime/data_time.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../pages/model/exercise.dart';
import '../pages/model/workouts.dart';

class HiveDatabase{
  
//reference our hive box
final  _myBox = Hive.box('workout_database1');

  get workoutList => String;
  
  get exerciseList => String;


//check if there is data stored, if not, record the start date
bool previousDataExists(){
  if (_myBox.isEmpty){
    print('Previous data does not exist');
    _myBox.put("START_DATE", todaysDateYYYYMMDD());
    return false;
  }else{
    print('Previous data does exist');
    return true;
  }
}


//return start date as yyyymmdd
String getStartDate(){
  return _myBox.get('START_DATE');
}

//write data 
void saveToDatabase(List<Workout>workouts){
  //convert workout objects into lists of strings so that we can save in hive
  final workoutList = convertObjectToWorkoutList(workouts);
  final exerciseList = convertObjectToExerciseList(workouts);
}

  convertObjectToExerciseList(List<Workout> workouts) {
     /*
   
   check if any exercises have been done
   we wil put a 0 or 1 for each yyyyddmm date

  */

  if(exerciseCompleted(workouts)){
    // ignore: prefer_interpolation_to_compose_strings
    _myBox.put('COMPLETION_STATUS' +todaysDateYYYYMMDD(), 1);
  } else{
     // ignore: prefer_interpolation_to_compose_strings
     _myBox.put('COMPLETION_STATUS' +todaysDateYYYYMMDD(), 0);
  }

  //save into hive
  _myBox.put('WORKOUTS', workoutList);
  _myBox.put('EXERCISE', exerciseList);
  }
  
 

//read data, and return a list of workouts
List<Workout>readFromDatabase(){
  List<Workout> mySavedWorkouts = [];

  List<String> workoutNames = _myBox.get('WORKOUTS');
  final exerciseDetails = _myBox.get('EXERCISES');

  //create workout objects
  for (int i= 0; i<workoutNames.length; i++) {
    //each workout can have multiple exercises
    List <Exercise> exercisesInEachWorkout = []; 

    for (int j=0; j<exerciseDetails[i].length; j++){
      //so add each exercise into a list
      exercisesInEachWorkout.add(
        Exercise(
          name: exerciseDetails[i][j][0], 
          weight: exerciseDetails[i][j][1], 
          reps: exerciseDetails[i][j][2], 
          sets: exerciseDetails[i][j][3],
          isCompleted: exerciseDetails[i][j][4] == 'true' ? true: false,
          )
      );
    }
    //create individual workout
    Workout workout = Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);

    //add individual workout to overall list
    mySavedWorkouts.add(workout);
  }

  return mySavedWorkouts;
  }

//return completion status of a given date yyyymmdd
int getCompletionStatus(String yyyymmdd){
   //returns 0 or 1, if null then return 0
   int completionStatus = _myBox.get('COMPLETION_STATUS_$yyyymmdd') ?? 0;
   return completionStatus;
}
}


//check if any exercise has been done

bool exerciseCompleted(List<Workout>workouts){
  //go through each workout
  for (var workout in workouts){
    //go through each exercise in workout
    for (var exercise in workout.exercises){
      if(exercise.isCompleted){
        return true;
      }
    }
  }
  return false;
}


//converts workout objects into a list
List <String> convertObjectToWorkoutList(List<Workout>workouts){
  List <String> workoutList = [
    //e.g [upper body, lower body]
  ];

   for (int i=0; i<workouts.length; i++){
    //in each workout, add the name, followed by lists of exercises
    workoutList.add(
      workouts[i].name
    );
   }
   return workoutList; 
}

//converts the exercises in a workout objects onto a list of strings
List <String> convertObjectToExerciseList(List<Workout>workouts){
  List <String> exerciseList = [
    //e.g [upper body, lower body]
  ];

   for (int i=0; i<workouts.length; i++){
    //in each workout, add the name, followed by lists of exercises
    exerciseList.add(
      workouts[i].name
    );
   }
   return exerciseList; 
}
