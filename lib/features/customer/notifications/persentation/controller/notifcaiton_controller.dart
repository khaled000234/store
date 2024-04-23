
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/core/service/shared_pref/pref_keys.dart';
import 'package:store/core/service/shared_pref/shared_pref.dart';
import 'package:store/core/utils/app_strings.dart';
import 'package:store/features/customer/notifications/data/models/notification_model.dart';

class NotificationController {
  NotificationController();

  final notificationDataBase = FirebaseFirestore.instance
      .collection(usersCollection)
      .doc(SharedPref().getInt(PrefKeys.userId).toString())
      .collection(notificationCollection)
      .orderBy('created_at', descending: true);

  Stream<List<NotificationModel>> getNotificationList() {
    return notificationDataBase.snapshots().map((value) {
      return value.docs.map((doc) {
        final data = doc.data();
        return NotificationModel.fromJson(data);
      }).toList();
    });
  }
}
