import 'package:flutter/material.dart';
import 'package:gym_track_app/components/heat_map.dart';
import 'package:gym_track_app/data/workout_data.dart';
import 'package:gym_track_app/pages/workout_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  
  //text controller
  final newWorkoutNameController = TextEditingController();

  //create a new workout
  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Workout'),
        content: TextField(
          controller: newWorkoutNameController,
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

  //go to workout page
  void goToWorkoutPage(String workoutName){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> WorkoutPage(
      WorkoutName: workoutName,
    ),),);
  }

  //save button
  void save() {
    //get workout name from text controller
    String newWorkoutName = newWorkoutNameController.text;
    //add workout to workout data list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

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
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[500],
        appBar: AppBar(
          title: const Text('Gym Track'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            //Heat Map
              MyHeatMap(datasets: value.heatMapDataSet, startDateYYYYMMDD: value.getStartDate()),
            //Workout List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
          itemCount: value.getWorkoutList().length,
          itemBuilder: (context, index) => ListTile(
            title: Text(value.getWorkoutList()[index].name),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: ()=>
              goToWorkoutPage(value.getWorkoutList()[index].name) ,
            ),
          ),
        ),
          ],
        )
      ),
    );
  }
}
