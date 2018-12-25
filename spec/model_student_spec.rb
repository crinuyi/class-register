require File.join($__lib__,'database','database_service')
describe 'Model "Student"' do
    context 'obiekt modelu' do
        it 'tworzenie' do
            dbs = DatabaseService.new Sequel.sqlite
            s = Student.new
            expect(s).to be_instance_of Student
        end
    end

    context 'akcje CRUD' do
        before do
            @dbs = DatabaseService.new Sequel.sqlite
        end

        after do
            @dbs = nil
        end

        it 'dodawanie wpisów' do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.save

            f = Student[:firstname => 'Jan',:lastname => 'Kowalski']

            expect(f).not_to be nil
        end

        it 'modyfikowanie wpisów' do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.save


            f = Student[1]
            f.lastname = 'Nowak'
            f.save_changes

            s1 = Student[:lastname => 'Kowalski']
            s2 = Student[:lastname => 'Nowak']

            expect(s1).to be nil
            expect(s2).not_to be nil
        end

        it 'usuwanie wpisów' do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.save

            f = Student[1]
            f.delete

            s1 = Student[:lastname => 'Kowalski']
            expect(s1).to be nil
        end

        it 'czytanie wpisów' do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.save

            s = Student.new
            s.firstname = 'Artur'
            s.lastname = 'Nowak'
            s.birthdate = DateTime.new(1970,10,10)
            s.save

            s = Student.new
            s.firstname = 'Dariusz'
            s.lastname = 'Nazwisko'
            s.birthdate = DateTime.new(1971,1,1)
            s.save

            expect(Student.all.length).to eq 3
        end
    end
end