import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/employee/employee_event.dart';
import 'package:saasify/bloc/employee/employee_states.dart';
import 'package:saasify/data/models/employee/invite_employee_model.dart';
import 'package:saasify/di/app_module.dart';
import 'package:saasify/repositories/employee/employee_repository.dart';

class EmployeeBloc extends Bloc<EmployeeEvents, EmployeeStates> {
  final Map inviteDetails = {};
  Map<String, dynamic> employeeDetails = {
    "personal_info": <String, dynamic>{
      "active_status": 1,
    },
    "documents": <String, dynamic>{
      "aadhar": <String, dynamic>{},
      "passport": <String, dynamic>{}
    },
    "financial": <String, dynamic>{
      "finances": <String, dynamic>{},
      "bank_details": <String, dynamic>{}
    },
    "official": <String, dynamic>{
      "designations": [2],
      "department": [0],
    }
  };
  final EmployeeRepository _employeeRepository = getIt<EmployeeRepository>();

  EmployeeStates get initialState => InitialisingEmployeeStates();

  EmployeeBloc() : super(InitialisingEmployeeStates()) {
    on<InviteEmployee>(_inviteUser);
    on<UpdateEmployee>(_updateEmployee);
  }

  FutureOr<void> _inviteUser(
      InviteEmployee event, Emitter<EmployeeStates> emit) async {
    emit(InvitingEmployee());
    try {
      InviteEmployeeModel inviteEmployeeModel =
          await _employeeRepository.inviteEmployee(event.inviteDetails);
      if (inviteEmployeeModel.status == 200) {
        emit(InvitationSent(inviteEmployeeModel: inviteEmployeeModel));
      } else {
        emit(InvitingFailed(
            errorMessage: inviteEmployeeModel.message.toString()));
      }
    } catch (e) {
      emit(InvitingFailed(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _updateEmployee(
      UpdateEmployee event, Emitter<EmployeeStates> emit) async {
    emit(UpdatingEmployee());
    try {
      print(jsonEncode(employeeDetails));
      var addEmployeeModel = await _employeeRepository.updateEmployee(
          employeeDetails, event.employeeId ?? "");
      if (addEmployeeModel.status == 200) {
        emit(EmployeeUpdated(message: addEmployeeModel.message.toString()));
      } else {
        emit(UpdatingEmployeeFailed(
            errorMessage: addEmployeeModel.message.toString()));
      }
    } catch (e) {
      emit(UpdatingEmployeeFailed(errorMessage: e.toString()));
    }
  }

  void resetEmployeeDetails() {
    employeeDetails = {
      "personal_info": <String, dynamic>{
        "active_status": 1,
      },
      "documents": <String, dynamic>{
        "aadhar": <String, dynamic>{},
        "passport": <String, dynamic>{}
      },
      "financial": <String, dynamic>{
        "finances": <String, dynamic>{},
        "bank_details": <String, dynamic>{}
      },
      "official": <String, dynamic>{
        "designations": [2],
        "department": [0],
      }
    };
  }

  // FutureOr<void> getEmployeeById(
  //     GetEmployee event, Emitter<EmployeeStates> emit) async {
  //   emit(GettingEmployee());
  //   try {
  //     var employee = await _employeeRepository.getEmployee(event.employeeId);
  //     if (employee.status == 200) {
  //       emit(GotEmployee());
  //     } else {
  //       emit(GettingEmployeeFailed(errorMessage: employee.message.toString()));
  //     }
  //   } catch (e) {
  //     emit(GettingEmployeeFailed(errorMessage: e.toString()));
  //   }
  // }
}
