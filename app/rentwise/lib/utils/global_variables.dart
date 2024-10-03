import 'package:rentwise/screens/board_feed.dart';
import 'package:rentwise/screens/complaint_feed.dart';
import 'package:rentwise/screens/dashboard_manager.dart';
import 'package:rentwise/screens/dashboard_tenant.dart';
import 'package:rentwise/screens/notification_set.dart';
import 'package:rentwise/screens/property_feed.dart';
import 'package:rentwise/screens/property_tenant.dart';
import 'package:rentwise/screens/transaction_feed.dart';

const homeScreenManagerItems = [
  DashboardManager(),
  PropertyFeed(),
  TransactionFeed(),
  ComplaintFeed(),
  NotificationSet(),
  BoardFeed()
];

const homeScreenTenantItems = [
  DashboardTenant(),
  PropertyTenant(),
  TransactionFeed(),
  ComplaintFeed(),
  BoardFeed()
];

const apiURL = 'https://rentwise-api-2hekufgq6a-as.a.run.app';
//const apiURL = 'http://localhost:3000';
