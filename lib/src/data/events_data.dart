
import '../model/event_model.dart';

class EventsData {
  
  static List<Event> getEvents() {
    return [
      Event(
        id: '1',
        title: 'Sunday Service',
        date: DateTime(2024, 4, 7, 10, 0),
        location: 'Main Sanctuary',
        attendees: 150,
      ),
      Event(
        id: '2',
        title: 'Youth Bible Study',
        date: DateTime(2024, 4, 8, 18, 30),
        location: 'Youth Room',
        attendees: 25,
      ),
      Event(
        id: '3',
        title: 'Prayer Meeting',
        date: DateTime(2024, 4, 9, 19, 0),
        location: 'Chapel',
        attendees: 40,
      ),
      Event(
        id: '4',
        title: "Women's Fellowship",
        date: DateTime(2024, 4, 10, 10, 0),
        location: 'Fellowship Hall',
        attendees: 35,
      ),
      Event(
        id: '5',
        title: "Men's Breakfast",
        date: DateTime(2024, 4, 11, 7, 0),
        location: 'Fellowship Hall',
        attendees: 30,
      ),
      Event(
        id: '6',
        title: 'Choir Practice',
        date: DateTime(2024, 4, 11, 19, 0),
        location: 'Choir Room',
        attendees: 45,
      ),
      Event(
        id: '7',
        title: 'Childrens Ministry',
        date: DateTime(2024, 4, 12, 16, 0),
        location: 'Childrens Area',
        attendees: 50,
      ),
      Event(
        id: '8',
        title: 'Community Outreach',
        date: DateTime(2024, 4, 13, 9, 0),
        location: 'Community Center',
        attendees: 75,
      ),
      Event(
        id: '9',
        title: 'Marriage Seminar',
        date: DateTime(2024, 4, 14, 14, 0),
        location: 'Conference Room',
        attendees: 60,
      ),
      Event(
        id: '10',
        title: 'New Members Class',
        date: DateTime(2024, 4, 15, 18, 0),
        location: 'Classroom 101',
        attendees: 15,
      ),
      Event(
        id: '11',
        title: 'Senior Adults Luncheon',
        date: DateTime(2024, 4, 16, 12, 0),
        location: 'Fellowship Hall',
        attendees: 55,
      ),
      Event(
        id: '12',
        title: 'Bible Study Workshop',
        date: DateTime(2024, 4, 17, 19, 0),
        location: 'Library',
        attendees: 30,
      ),
      Event(
        id: '13',
        title: 'Youth Game Night',
        date: DateTime(2024, 4, 18, 18, 0),
        location: 'Youth Room',
        attendees: 40,
      ),
      Event(
        id: '14',
        title: 'Missions Committee',
        date: DateTime(2024, 4, 19, 17, 0),
        location: 'Conference Room',
        attendees: 12,
      ),
      Event(
        id: '15',
        title: 'Worship Team Practice',
        date: DateTime(2024, 4, 20, 16, 0),
        location: 'Sanctuary',
        attendees: 20,
      ),
      Event(
        id: '16',
        title: 'Family Movie Night',
        date: DateTime(2024, 4, 21, 19, 0),
        location: 'Fellowship Hall',
        attendees: 100,
      ),
      Event(
        id: '17',
        title: 'Leadership Meeting',
        date: DateTime(2024, 4, 22, 18, 30),
        location: 'Conference Room',
        attendees: 15,
      ),
      Event(
        id: '18',
        title: 'Young Adults Fellowship',
        date: DateTime(2024, 4, 23, 19, 0),
        location: 'Coffee Shop',
        attendees: 35,
      ),
      Event(
        id: '19',
        title: 'Prayer Breakfast',
        date: DateTime(2024, 4, 24, 7, 0),
        location: 'Fellowship Hall',
        attendees: 45,
      ),
      Event(
        id: '20',
        title: 'Community Service Day',
        date: DateTime(2024, 4, 25, 9, 0),
        location: 'Various Locations',
        attendees: 120,
      ),
    ];
  }


}