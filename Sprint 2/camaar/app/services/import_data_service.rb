class ImportDataService

  def self.import_all
    begin
      classes_path = Rails.root.join('classes.json')
      members_path = Rails.root.join('class_members.json')

      json_exists = File.exist?(classes_path) &&
                    File.exist?(members_path)

      unless json_exists
        return {
          success: false,
          error: 'Arquivos não localizados'
        }
      end

      classes_data = JSON.parse(File.read(classes_path))
      members_data = JSON.parse(File.read(members_path))

      import_disciplinas_classes(classes_data)

      import_users_members(members_data)

      { success: true }

    rescue JSON::ParserError
      {
        success: false,
        error: 'Erro ao ler os arquivos JSON'
      }
    end
  end

  private

  def self.import_disciplinas_classes(classes_data)

    classes_data.each do |class_data|

      department = class_data['code'].gsub(/[0-9]/, '').strip

      disciplina = Disciplina.find_or_create_by(
        codigo: class_data['code']
      ) do |d|
        d.nome = class_data['name']
        d.department = department
      end

      turma_info = class_data['class']

      Turma.find_or_create_by(
        codigo: turma_info['classCode'],
        semestre: turma_info['semester'],
        disciplina: disciplina
      ) do |t|
        t.horario = turma_info['time']
        t.disciplina = disciplina
      end
    end
  end

  def self.import_users_members(members_data)

    members_data.each do |member_data|

      turma = Turma.find_by(
        codigo: member_data['classCode'],
        semestre: member_data['semester']
      )

      next unless turma

      alunos = member_data['dicente'] || []

      alunos.each do |aluno_data|

        user = User.find_or_create_by(
          matricula: aluno_data['matricula']
        ) do |u|
          u.name = aluno_data['nome']
          u.email = aluno_data['email']
          u.password = SecureRandom.hex(8)
        end

        TurmaAluno.find_or_create_by(
          turma: turma,
          aluno_id: user.id
        )
      end
    end
  end
end