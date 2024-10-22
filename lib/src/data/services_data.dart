
import '../model/services_model.dart';

class ServicesData {

   
  static List<Service> getServices() {
    return [
      const Service(
        id: '1',
        name: 'Sunday Morning Worship',
        description: 'Main weekly worship service',
        minister: 'Rev. Michael Smith',
        schedule: 'Sunday 10:00 AM',
      ),
      const Service(
        id: '2',
        name: 'Early Morning Prayer',
        description: 'Daily morning prayer service',
        minister: 'Pastor Sarah Johnson',
        schedule: 'Daily 6:00 AM',
      ),
      const Service(
        id: '3',
        name: 'Youth Service',
        description: 'Weekly youth worship and teaching',
        minister: 'Youth Pastor Alex Wilson',
        schedule: 'Wednesday 6:30 PM',
      ),
      const Service(
        id: '4',
        name: 'Childrens Church',
        description: 'Childrens worship and Bible lessons',
        minister: 'Mrs. Emma Davis',
        schedule: 'Sunday 10:00 AM',
      ),
      const Service(
        id: '5',
        name: 'Evening Bible Study',
        description: 'In-depth Bible study and discussion',
        minister: 'Dr. James Thompson',
        schedule: 'Tuesday 7:00 PM',
      ),
      const Service(
        id: '6',
        name: 'Spanish Service',
        description: 'Worship service in Spanish',
        minister: 'Pastor Carlos Rodriguez',
        schedule: 'Sunday 12:00 PM',
      ),
      const Service(
        id: '7',
        name: 'Healing Service',
        description: 'Prayer for healing and restoration',
        minister: 'Rev. John Anderson',
        schedule: 'Friday 7:00 PM',
      ),
      const Service(
        id: '8',
        name: 'Contemporary Worship',
        description: 'Modern worship service',
        minister: 'Worship Pastor David Lee',
        schedule: 'Sunday 5:00 PM',
      ),
      const Service(
        id: '9',
        name: 'Senior Adults Ministry',
        description: 'Fellowship and worship for seniors',
        minister: 'Pastor Mary Wilson',
        schedule: 'Thursday 10:00 AM',
      ),
      const Service(
        id: '10',
        name: 'Young Adults Service',
        description: 'Worship and fellowship for young adults',
        minister: 'Pastor Kevin Taylor',
        schedule: 'Friday 7:30 PM',
      ),
      const Service(
        id: '11',
        name: 'Marriage Ministry',
        description: 'Counseling and support for couples',
        minister: 'Dr. & Mrs. Brown',
        schedule: 'Monday 6:30 PM',
      ),
      const Service(
        id: '12',
        name: 'Prayer Warriors',
        description: 'Intercessory prayer group',
        minister: 'Sister Grace Miller',
        schedule: 'Wednesday 12:00 PM',
      ),
      const Service(
        id: '13',
        name: 'Mens Fellowship',
        description: 'Bible study and fellowship for men',
        minister: 'Brother Thomas Clark',
        schedule: 'Saturday 8:00 AM',
      ),
      const Service(
        id: '14',
        name: 'Womens Bible Study',
        description: 'Bible study and fellowship for women',
        minister: 'Pastor Rachel Green',
        schedule: 'Tuesday 10:00 AM',
      ),
      const Service(
        id: '15',
        name: 'College Ministry',
        description: 'Worship and study for college students',
        minister: 'Pastor Brian White',
        schedule: 'Thursday 8:00 PM',
      ),
      const Service(
        id: '16',
        name: 'Traditional Service',
        description: 'Traditional hymns and worship',
        minister: 'Rev. William Moore',
        schedule: 'Sunday 8:00 AM',
      ),
      const Service(
        id: '17',
        name: 'New Believers Class',
        description: 'Foundation course for new Christians',
        minister: 'Pastor Linda Martinez',
        schedule: 'Sunday 9:00 AM',
      ),
      const Service(
        id: '18',
        name: 'Worship Practice',
        description: 'Music team rehearsal',
        minister: 'Music Director Paul Adams',
        schedule: 'Thursday 7:00 PM',
      ),
      const Service(
        id: '19',
        name: 'Childrens Choir',
        description: 'Music training for children',
        minister: 'Mrs. Jennifer Lewis',
        schedule: 'Wednesday 5:00 PM',
      ),
      const Service(
        id: '20',
        name: 'Missions Service',
        description: 'Mission updates and prayer',
        minister: 'Missions Director Mark Wilson',
        schedule: 'Last Sunday 6:00 PM',
      ),
    ];
  }
}