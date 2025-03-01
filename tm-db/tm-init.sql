-- Tạo schema riêng
CREATE SCHEMA timetable_master;

-- Tạo bảng năm học
CREATE TABLE timetable_master.academic_years (
    id SERIAL PRIMARY KEY,
    start_year INT NOT NULL,
    end_year INT NOT NULL,
    UNIQUE (start_year, end_year)
);

-- Tạo bảng học kỳ
CREATE TABLE timetable_master.semesters (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) CHECK (name IN ('Học kỳ 1', 'Học kỳ 2')) NOT NULL,
    academic_year_id INT REFERENCES timetable_master.academic_years(id) ON DELETE CASCADE
);

-- Tạo bảng giáo viên
CREATE TABLE timetable_master.teachers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    type VARCHAR(50) CHECK (type IN ('Nâng cao', 'Cơ bản')),
    employment_type VARCHAR(50) CHECK (employment_type IN ('Hợp đồng', 'Biên chế')) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE, -- TRUE: Đang làm, FALSE: Đã nghỉ
    max_lessons_per_week INT DEFAULT 20
);

-- Tạo bảng lớp học
CREATE TABLE timetable_master.classes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    grade INT NOT NULL,
    homeroom_teacher_id INT REFERENCES timetable_master.teachers(id) ON DELETE SET NULL
);

-- Tạo bảng môn học
CREATE TABLE timetable_master.subjects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

-- Tạo bảng môn học cho từng lớp
CREATE TABLE timetable_master.class_subjects (
    id SERIAL PRIMARY KEY,
    class_id INT REFERENCES timetable_master.classes(id) ON DELETE CASCADE,
    subject_id INT REFERENCES timetable_master.subjects(id) ON DELETE CASCADE,
    semester_id INT REFERENCES timetable_master.semesters(id) ON DELETE CASCADE,
    UNIQUE (class_id, subject_id, semester_id)
);

-- Tạo bảng thời khóa biểu
CREATE TABLE timetable_master.schedules (
    id SERIAL PRIMARY KEY,
    class_id INT REFERENCES timetable_master.classes(id) ON DELETE CASCADE,
    teacher_id INT REFERENCES timetable_master.teachers(id) ON DELETE SET NULL,
    subject_id INT REFERENCES timetable_master.subjects(id) ON DELETE CASCADE,
    semester_id INT REFERENCES timetable_master.semesters(id) ON DELETE CASCADE,
    day_of_week INT CHECK (day_of_week BETWEEN 1 AND 7),
    lesson_number INT CHECK (lesson_number BETWEEN 1 AND 10),
    UNIQUE (class_id, semester_id, day_of_week, lesson_number)
);

-- Tạo bảng người dùng (user) để mở rộng sau này
CREATE TABLE timetable_master.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role VARCHAR(50) CHECK (role IN ('Admin', 'Hiệu trưởng')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
