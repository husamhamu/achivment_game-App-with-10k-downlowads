import 'dart:io';
import 'package:achivment_game/constants.dart';
import 'package:achivment_game/models/reward_list_class.dart';
import 'package:achivment_game/screens/rewards_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddRewardsScreen extends StatefulWidget {
  static final String id = 'AddRewardsScreen';
  final Function addReward;

  AddRewardsScreen({this.addReward});

  @override
  _AddRewardsScreenState createState() => _AddRewardsScreenState();
}

class _AddRewardsScreenState extends State<AddRewardsScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textEditingController0;
  TextEditingController _textEditingController1;
  StepState _stepState0 = StepState.editing;
  StepState _stepState1 = StepState.indexed;
  StepState _stepState2 = StepState.indexed;
  bool isActive0 = true;
  bool isActive1 = false;
  bool isActive2 = false;
  int currentStep = 0;
  bool complete = false;
  File _imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _textEditingController0 = TextEditingController();
    _textEditingController1 = TextEditingController();
  }

  Future<void> _addImage() async {
    final _pickedImage =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 70);
    if (_pickedImage != null) {
      setState(() {
        _imageFile = File(_pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<Step> steps = [
      Step(
        title: const Text(
          'Title',
          style: kTextStyle,
        ),
        state: _stepState0,
        isActive: isActive0,
        content: TextField(
          maxLength: 50,
          minLines: 1,
          maxLines: 2,
          controller: _textEditingController0,
          keyboardType: TextInputType.text,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Title',
            icon: Icon(Icons.title),
          ),
        ),
      ),
      Step(
        title: const Text(
          'Points',
          style: kTextStyle,
        ),
        state: _stepState1,
        isActive: isActive1,
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _textEditingController1,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Points up to 1000',
              icon: const Icon(Icons.monetization_on),
            ),
            validator: (value) {
              if (int.tryParse(value) == null) {
                return 'Enter only numbers';
              } else if (int.parse(value) == 0) {
                return 'Points can not be 0';
              } else if (int.parse(value) > 1000) {
                return '1000 is the limit';
              } else {
                return null;
              }
            },
            onChanged: (_) {
              _formKey.currentState.validate();
            },
          ),
        ),
      ),
      Step(
        title: const Text(
          'Image',
          style: kTextStyle,
        ),
        state: _stepState2,
        isActive: isActive2,
        content: Column(
          children: <Widget>[
            Container(
              child: _imageFile != null
                  ? Image.file(
                      _imageFile,
                      fit: BoxFit.cover,
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.3,
                    )
                  : Text('image'),
            ),
            Container(
              width: screenWidth - (0.01 * screenWidth),
              height: screenHeight - (0.8 * screenHeight),
              child: FittedBox(
                child: FlatButton.icon(
                  onPressed: _addImage,
                  icon: const Icon(
                    Icons.image,
                    color: Colors.blue,
                  ),
                  label: const Text(
                    'Add from gallery',
                    style: TextStyle(color: Colors.blue, fontSize: 8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    void goTo(int stepIndex) {
      setState(() {
        currentStep = stepIndex;
//        FocusScope.of(context).requestFocus(_focusNode);
//        _focusNode.requestFocus(FocusNode());
        if (currentStep == 0) {
          isActive0 = true;
          isActive1 = false;
          isActive2 = false;
          _stepState0 = StepState.editing;
          _stepState1 = StepState.indexed;
          _stepState2 = StepState.indexed;
        }
        if (currentStep == 1) {
          isActive0 = false;
          isActive1 = true;
          isActive2 = false;
          _stepState0 = StepState.complete;
          _stepState1 = StepState.editing;
          _stepState2 = StepState.indexed;
        }
        if (currentStep == 2) {
          isActive0 = false;
          isActive1 = false;
          isActive2 = true;
          _stepState0 = StepState.complete;
          _stepState1 = StepState.complete;
          _stepState2 = StepState.editing;
        }
      });
    }

    void cancel() {
      if (currentStep != 0) {
        setState(() {
          goTo(currentStep - 1);
        });
      }
    }

    void nextStep() async {
      if ((currentStep + 1) != steps.length) {
        if (currentStep == 1) {
          if (_formKey.currentState.validate()) {
            goTo(currentStep + 1);
          }
        } else if (currentStep == 0) {
          if (_textEditingController0.text.length > 0) {
            print(_textEditingController0.text);
            goTo(currentStep + 1);
          }
        } else {
          goTo(currentStep + 1);
        }
      } else {
        //that means the all steps finished
        if (_imageFile != null) {
          Provider.of<RewardList>(context, listen: false).addReward(
            int.parse(_textEditingController1.text),
            _textEditingController0.text,
            _imageFile.path,
          );
          widget.addReward();
          Navigator.pop(context);

          final dialog = await showDialog(
            context: context,
            child: AlertDialog(
              elevation: 5,
              content: Wrap(
                children: <Widget>[
                  Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: _textEditingController0.text,
                            style: TextStyle(color: Colors.black)),
                        const TextSpan(
                            text: ' was added successfully',
                            style: const TextStyle(
                              color: Colors.green,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stepper(
            steps: steps,
            currentStep: currentStep,
            onStepCancel: cancel,
            onStepContinue: nextStep,
            onStepTapped: (stepIndex) => goTo(stepIndex),
            type: StepperType.horizontal,
          ),
        ),
      ),
    );
  }
}
