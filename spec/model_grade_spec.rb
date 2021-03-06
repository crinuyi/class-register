require File.join($__lib__,'database','database_service')
describe 'Model "Grade"' do
    context 'obiekt modelu' do
        it 'tworzenie' do
            dbs = DatabaseService.new Sequel.sqlite
            g = Grade.new
            expect(g).to be_instance_of Grade
        end
    end


    context 'akcje CRUD' do
      before do
        @dbs = DatabaseService.new Sequel.sqlite
      end

      it 'dodawanie wpisów' do
        st = Student.new
        st.firstname = 'Jan'
        st.lastname = 'Kowalski'
        st.birthdate = DateTime.new(1970,1,1)
        st.student_class = '3A'
        st.student_number = 4
        st.save

        su = Subject.new
        su.name = "Matematyka"
        su.save

        g = Grade.new
        g.grade = '4-'
        g.student = st
        g.subject = su
        g.date = DateTime.new(1970,1,1)
        g.save

        expect(Grade.select.all.count).to eq 1
      end

      it 'modyfikowanie wpisów' do
        st = Student.new
        st.firstname = 'Jan'
        st.lastname = 'Kowalski'
        st.birthdate = DateTime.new(1970,1,1)
        st.student_class = '3A'
        st.student_number = 4
        st.save

        su = Subject.new
        su.name = "Matematyka"
        su.save

        g = Grade.new
        g.grade = '4-'
        g.student = st
        g.subject = su
        g.date = DateTime.new(1970,1,1)
        g.save

        g.grade = '5+'
        g.date = DateTime.new(1971,1,1)
        g.save

        expect([Grade[g.id].grade]).to eq ['5+']
      end

      it 'usuwanie wpisów' do
        st = Student.new
        st.firstname = 'Jan'
        st.lastname = 'Kowalski'
        st.birthdate = DateTime.new(1970,1,1)
        st.student_class = '3A'
        st.student_number = 4
        st.save

        su = Subject.new
        su.name = "Matematyka"
        su.save

        g = Grade.new
        g.grade = '4-'
        g.student = st
        g.subject = su
        g.date = DateTime.new(1970,1,1)
        g.save

        g.delete

        expect(Note.select.all.count).to eq 0
      end

      it 'czytanie wpisów' do
        st1 = Student.new
        st1.firstname = 'Jan'
        st1.lastname = 'Kowalski'
        st1.birthdate = DateTime.new(1970,1,1)
        st1.student_class = '3A'
        st1.student_number = 4
        st1.save

        su = Subject.new
        su.name = "Matematyka"
        su.save

        g = Grade.new
        g.grade = '4-'
        g.student = st1
        g.subject = su
        g.date = DateTime.new(1970,1,1)
        g.save

        g = Grade.new
        g.grade = '2'
        g.student = st1
        g.subject = su
        g.date = DateTime.new(1970,1,1)
        g.save

        expect(Grade.select.all.count).to eq 2
      end
    end

  context 'walidacja' do
    before do
      @dbs = DatabaseService.new Sequel.sqlite
    end

    let(:invalid_grades) do
      [
          [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, nil, "1-1-1970"],
          [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 3, nil],
          [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 5542, nil],
          [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 5542, [1,2,3]],
          [Student.new {|s| s.id=1}, Student.new {|s| s.id=1}, '39 ', DateTime.new(1970,1,1)],
          [Student.new {|s| s.id=1}, nil, '3', "1-1-1970"],
          [Student.new {|s| s.id=1}, nil, '3+',DateTime.new(1970,1,1)],
          [Student.new {|s| s.id=1}, nil, 5542, DateTime.new(1970,1,1)],
          [nil, nil, '3+', DateTime.new(1970,1,1)]
      ]
    end

    it 'poprawny wpis' do
      st = Student.new
      st.firstname = 'Jan'
      st.lastname = 'Kowalski'
      st.birthdate = DateTime.new(1970,1,1)
      st.student_class = '3A'
      st.student_number = 4
      st.save

      su = Subject.new
      su.name = "Matematyka"
      su.save

      g = Grade.new
      g.grade = '4-'
      g.student = st
      g.subject = su
      g.date = DateTime.new(1970,1,1)
      g.save

      expect(g.valid?).to be true
    end

    it 'niepoprawne wpisy' do
      invalid_grades.each do |grade|
        g = Grade.new
        g.student = grade[0]
        g.subject = grade[1]
        g.grade = grade[2]
        g.date = grade[3]
        expect(g.valid?).to be false
      end
    end
  end

  context 'asocjacja grade-student' do
    before do
      @dbs = DatabaseService.new Sequel.sqlite
    end

    it 'dostęp do obiektu student' do
      s = Student.new
      s.firstname = 'Jan'
      s.lastname = 'Kowalski'
      s.birthdate = DateTime.new(1970,1,1)
      s.student_class = '3A'
      s.student_number = 4
      s.save

      su = Subject.new
      su.name = "Matematyka"
      su.save

      g = Grade.new
      g.grade = '4-'
      g.student = s
      g.subject = su
      g.date = DateTime.new(1970,1,1)
      g.save

      g.student.lastname='Kowalskii'
      g.student.save

      s1 = Student[:lastname => 'Kowalski']
      s2 = Student[:lastname => 'Kowalskii']

      expect(s1).to be nil
      expect(s2).not_to be nil
    end
  end

  context 'asocjacja grade-subject' do
    before do
      @dbs = DatabaseService.new Sequel.sqlite
    end

    it 'dostęp do obiektu subject' do
      s = Student.new
      s.firstname = 'Jan'
      s.lastname = 'Kowalski'
      s.birthdate = DateTime.new(1970,1,1)
      s.student_class = '3A'
      s.student_number = 4
      s.save

      su = Subject.new
      su.name = "Matematyka"
      su.save

      g = Grade.new
      g.grade = '4-'
      g.student = s
      g.subject = su
      g.date = DateTime.new(1970,1,1)
      g.save

      g.subject.name = "Fizyka"
      g.subject.save

      s1 = Subject[:name => 'Matematyka']
      s2 = Subject[:name => 'Fizyka']

      expect(s1).to be nil
      expect(s2).not_to be nil
    end
  end

    context 'metody związane z obsługą menu' do
      before do
        @dbs = DatabaseService.new Sequel.sqlite
      end

      it "drukowanie nagłówka tabeli" do
        expect(Grade.print_header).to eq("Id   | Przedmiot                      | Data wystawienia          | Ocena | Nazwisko                      \n---------------------------------------------------------------------------------------------------------------")
      end

      it "drukowanie oceny" do
        s = Student.new
        s.firstname = 'Jan'
        s.lastname = 'Kowalski'
        s.birthdate = DateTime.new(1970,1,1)
        s.student_class = '3A'
        s.student_number = 4
        s.save

        su = Subject.new
        su.name = "Matematyka"
        su.save

        g = Grade.new
        g.grade = '4-'
        g.student = s
        g.subject = su
        g.date = DateTime.new(1970,1,1)
        g.save

        expect(g.to_s).to eq("1    | Matematyka                     | 1970-01-01                | 4-    | Kowalski                      ")
      end
    end

    context 'zapytania' do
      before do
        @dbs = DatabaseService.new Sequel.sqlite
      end

      it "pobieranie ocen z danego przedmiotu gdy istnieją" do
        s = Student.new
        s.firstname = 'Jan'
        s.lastname = 'Kowalski'
        s.birthdate = DateTime.new(1970,1,1)
        s.student_class = '3A'
        s.student_number = 4
        s.save

        su = Subject.new
        su.name = "Matematyka"
        su.save

        g = Grade.new
        g.grade = '4-'
        g.student = s
        g.subject = su
        g.date = DateTime.new(1970,1,1)
        g.save

        g2 = Grade.new
        g2.grade = '5+'
        g2.student = s
        g2.subject = su
        g2.date = DateTime.new(1970,1,1)
        g2.save

        expect(Grade.get_by_subject su).to eq([g, g2])
      end

      it "pobieranie ocen z danego przedmiotu gdy nie istnieją" do
        su = Subject.new
        su.name = "Matematyka"
        su.save

        expect(Grade.get_by_subject su).to eq(nil)
      end

      it "pobieranie ocen na podstawie studenta i przedmiotu gdy istnieją" do
        s = Student.new
        s.firstname = 'Jan'
        s.lastname = 'Kowalski'
        s.birthdate = DateTime.new(1970,1,1)
        s.student_class = '3A'
        s.student_number = 4
        s.save

        su = Subject.new
        su.name = "Matematyka"
        su.save

        g = Grade.new
        g.grade = '4-'
        g.student = s
        g.subject = su
        g.date = DateTime.new(1970,1,1)
        g.save

        expect(Grade.get_by_student_and_subject s,su).to eq([g])
      end

      it "pobieranie ocen na podstawie studenta i przedmiotu gdy nie istnieją" do
        s = Student.new
        s.firstname = 'Jan'
        s.lastname = 'Kowalski'
        s.birthdate = DateTime.new(1970,1,1)
        s.student_class = '3A'
        s.student_number = 4
        s.save

        su = Subject.new
        su.name = "Matematyka"
        su.save

        expect(Grade.get_by_student_and_subject s,su).to eq(nil)
      end

      

      it "zmiana oceny na wartość liczbową - wartość bez znaku" do
        s = Student.new
        s.firstname = 'Jan'
        s.lastname = 'Kowalski'
        s.birthdate = DateTime.new(1970,1,1)
        s.student_class = '3A'
        s.student_number = 4
        s.save

        su = Subject.new
        su.name = "Matematyka"
        su.save

        g = Grade.new
        g.grade = '4'
        g.student = s
        g.subject = su
        g.date = DateTime.new(1970,1,1)
        g.save

        expect(g.to_f).to be_within(0.0001).of(4.0)
      end

      it "zmiana oceny na wartość liczbową - wartość ze znakiem" do
        s = Student.new
        s.firstname = 'Jan'
        s.lastname = 'Kowalski'
        s.birthdate = DateTime.new(1970,1,1)
        s.student_class = '3A'
        s.student_number = 4
        s.save

        su = Subject.new
        su.name = "Matematyka"
        su.save

        g = Grade.new
        g.grade = '4-'
        g.student = s
        g.subject = su
        g.date = DateTime.new(1970,1,1)
        g.save

        expect(g.to_f).to be_within(0.0001).of(3.66666)
      end
    end
end