package matrix22;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

class Internship {
    private final String name;
    private double minGrade;
    List<Student> students;

    public Internship(final String initName, final double initMinGrade) {
        name = initName;

        if (initMinGrade <= 0) {
            minGrade = 1;
        } else if (initMinGrade > 10) {
            minGrade = 10;
        } else {
            minGrade = initMinGrade;
        }

        students = new ArrayList<>();
    }

    public String getName() {
        return name;
    }

    public double getMinGrade() {
        return minGrade;
    }

    public boolean addStudent(Student student) {
        if (student != null) {
            return students.add(student);
        }

        return false;
    }

    public Student chooseCandidateRandomly() {
        return students.get(new Random().nextInt(students.size()));
    }

    public void chooseCandidatesForInterview() {
        for (Student stud : students) {
            if (stud.getGrade() >= minGrade) {
                System.out.println("Candidate [" + stud.getName() + "] got a phone interview at [" + name + "]");
            }
        }
    }

}
