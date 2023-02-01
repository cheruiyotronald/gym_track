import 'package:flutter/material.dart';
import 'package:gym_track_app/components/exercise_tile.dart';
import 'package:gym_track_app/data/workout_data.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String WorkoutName;
  const WorkoutPage({super.key, required this.WorkoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //checkbox was tapped
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }
  //text controllers
final exerciseNameController = TextEditingController();
final weightController = TextEditingController();
final repsController = TextEditingController();
final setsController = TextEditingController();


  //create a new exercise
  void createNewExercise(){
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: Text('Add a new exercise'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        //exercise name
        TextField(
          controller: exerciseNameController,
        ),

        //weight
        TextField(
          controller: weightController,
        ),

        //reps
        TextField(
          controller: repsController,
        ),

        //sets
        TextField(
          controller: setsController,
        ),
      ],
      ),
      actions: [
        //save button
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
          ),

          //cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancel'),
          ),
      ],
    ),
    );
  }
    //save button
  void save() {
    //get exercise name from text controller
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    //add exercise to workout 
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.WorkoutName, 
      newExerciseName, 
      weight, 
      reps, 
      sets,
      );

    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  //cancel button
  void cancel() {
    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  //void clear controllers
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.WorkoutName),),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewExercise,
            child: Icon(Icons.add),
          ),
        body: ListView.builder(
          itemCount: value.numberOfExercisesInWorkout(widget.WorkoutName),
          itemBuilder: (context, index) => ExerciseTile(
            exerciseName: value
                .getRelevantWorkout(widget.WorkoutName)
                .exercises[index]
                .name,
            weight: value
                .getRelevantWorkout(widget.WorkoutName)
                .exercises[index]
                .weight,
            reps: value
                .getRelevantWorkout(widget.WorkoutName)
                .exercises[index]
                .reps,
            sets: value
                .getRelevantWorkout(widget.WorkoutName)
                .exercises[index]
                .sets,
            isCompleted: value
                .getRelevantWorkout(widget.WorkoutName)
                .exercises[index]
                .isCompleted,
            onCheckBoxChanged: (val) => onCheckBoxChanged(
                widget.WorkoutName,
                value
                    .getRelevantWorkout(widget.WorkoutName)
                    .exercises[index]
                    .name),
          ),
        ),
      ),
    );
  }
}
