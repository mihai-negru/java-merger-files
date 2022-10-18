package matrix22;

public class JobMarket {
    public static void main(String[] args) {
        Student[] students = new Student[4];
        students[0] = new Student("Gigel", 10);
        students[1] = new Student("Dorel", 7.3);
        students[2] = new Student("Marcel", 8.4);
        students[3] = new Student("Ionel", 6.2);

        Internship[] internships = new Internship[4];
        internships[0] = new Internship("Google", 7);
        internships[1] = new Internship("Amazon", 9.3);
        internships[2] = new Internship("Facebook", 5);
        internships[3] = new Internship("Microsoft", 8);

        for (final Internship internship : internships) {
            for (final Student student : students) {
                if (!internship.addStudent(student)) {
                    System.out.println(
                            "Student [" + student.getName() + "] could not be added at [" + internship.getName() +
                                    "]");
                }
            }

            internship.chooseCandidatesForInterview();
            System.out.println();
        }
    }
}
