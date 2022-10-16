package matrix22;

public class Student {
    private final String name;
    private double grade;

    public Student(final String initName, final double initGrade) {
        name = initName;

        if (initGrade <= 0) {
            grade = 1;
        } else if (initGrade > 10) {
            grade = 10;
        } else {
            grade = initGrade;
        }
    }

    public String getName() {
        return name;
    }

    public double getGrade() {
        return grade;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Student) {
            Student stud = (Student) obj;

            return (stud.name.equals(name)) && (stud.grade == grade);
        }

        return false;
    }
}