# Responsável por importar disciplinas, turmas e usuários
# a partir dos arquivos JSON exportados do SIGAA.
# Responsável por importar disciplinas, turmas e usuários
# a partir dos arquivos JSON exportados do SIGAA.
class ImportDataService

  CLASSES_PATH = Rails.root.join('..', '..', 'classes.json').freeze
  MEMBERS_PATH = Rails.root.join('..', '..', 'class_members.json').freeze


  CLASSES_PATH = Rails.root.join('..', '..', 'classes.json').freeze
  MEMBERS_PATH = Rails.root.join('..', '..', 'class_members.json').freeze


  def self.import_all
    return arquivos_ausentes unless files_exist?

    classes_data, members_data = load_json_files
    importar_dados(classes_data, members_data)
    return arquivos_ausentes unless files_exist?

    classes_data, members_data = load_json_files
    importar_dados(classes_data, members_data)

    { success: true }
  rescue JSON::ParserError
    { success: false, error: 'Erro ao ler os arquivos JSON' }
    { success: true }
  rescue JSON::ParserError
    { success: false, error: 'Erro ao ler os arquivos JSON' }
  end

  private

  def self.files_exist?
    File.exist?(CLASSES_PATH) && File.exist?(MEMBERS_PATH)
  end

  def self.arquivos_ausentes
    { success: false, error: 'Arquivos não localizados' }
  end

  def self.load_json_files
    [
      JSON.parse(File.read(CLASSES_PATH)),
      JSON.parse(File.read(MEMBERS_PATH))
    ]
  end

  def self.importar_dados(classes_data, members_data)
    import_disciplinas_classes(classes_data)
    import_users_members(members_data)
  end

  def self.files_exist?
    File.exist?(CLASSES_PATH) && File.exist?(MEMBERS_PATH)
  end

  def self.arquivos_ausentes
    { success: false, error: 'Arquivos não localizados' }
  end

  def self.load_json_files
    [
      JSON.parse(File.read(CLASSES_PATH)),
      JSON.parse(File.read(MEMBERS_PATH))
    ]
  end

  def self.importar_dados(classes_data, members_data)
    import_disciplinas_classes(classes_data)
    import_users_members(members_data)
  end

  def self.import_disciplinas_classes(classes_data)
    classes_data.each do |class_data|
      disciplina = import_disciplina(class_data)
      import_turma(class_data, disciplina)
    end
  end

  def self.import_disciplina(class_data)
    codigo = class_data['code']
    Disciplina.find_or_create_by(codigo: codigo) do |disciplina|
      disciplina.nome       = class_data['name']
      disciplina.department = codigo.gsub(/[0-9]/, '').strip
    end
  end

  def self.import_turma(class_data, disciplina)
    turma_info = class_data['class']
    Turma.find_or_create_by(
      codigo:     turma_info['classCode'],
      semestre:   turma_info['semester'],
      disciplina: disciplina
    ) do |turma|
      turma.horario = turma_info['time']
      disciplina = import_disciplina(class_data)
      import_turma(class_data, disciplina)
    end
  end

  def self.import_disciplina(class_data)
    codigo = class_data['code']
    Disciplina.find_or_create_by(codigo: codigo) do |disciplina|
      disciplina.nome       = class_data['name']
      disciplina.department = codigo.gsub(/[0-9]/, '').strip
    end
  end

  def self.import_turma(class_data, disciplina)
    turma_info = class_data['class']
    Turma.find_or_create_by(
      codigo:     turma_info['classCode'],
      semestre:   turma_info['semester'],
      disciplina: disciplina
    ) do |turma|
      turma.horario = turma_info['time']
    end
  end

  def self.import_users_members(members_data)
    members_data.each { |member_data| import_member(member_data) }
  end
    members_data.each { |member_data| import_member(member_data) }
  end

  def self.import_member(member_data)
    turma = Turma.find_by(
      codigo:   member_data['classCode'],
      semestre: member_data['semester']
    )
    return unless turma
  def self.import_member(member_data)
    turma = Turma.find_by(
      codigo:   member_data['classCode'],
      semestre: member_data['semester']
    )
    return unless turma

    docente = member_data['docente']
    import_dicentes(member_data['dicente'] || [], turma)
    import_teacher(docente, turma) if docente.present?
  end

  def self.import_dicentes(dicentes, turma)
    dicentes.each { |aluno_data| import_student(aluno_data, turma) }
    docente = member_data['docente']
    import_dicentes(member_data['dicente'] || [], turma)
    import_teacher(docente, turma) if docente.present?
  end

  def self.import_dicentes(dicentes, turma)
    dicentes.each { |aluno_data| import_student(aluno_data, turma) }
  end

  def self.import_student(aluno_data, turma)
    matricula = aluno_data['matricula']
    user      = User.find_by(matricula: matricula) || create_student(aluno_data, matricula)
    TurmaAluno.find_or_create_by(turma: turma, aluno_id: user.id)
  end

  def self.create_student(aluno_data, matricula)
    curso = aluno_data['curso'] || ''
    User.create!(
      matricula:    matricula,
      name:         aluno_data['nome'],
      email:        aluno_data['email'],
      role:         'user',
      department:   curso.split('/').last,
      first_access: true,
      password:     SecureRandom.hex(16)
    )
  end
    matricula = aluno_data['matricula']
    user      = User.find_by(matricula: matricula) || create_student(aluno_data, matricula)
    TurmaAluno.find_or_create_by(turma: turma, aluno_id: user.id)
  end

  def self.create_student(aluno_data, matricula)
    curso = aluno_data['curso'] || ''
    User.create!(
      matricula:    matricula,
      name:         aluno_data['nome'],
      email:        aluno_data['email'],
      role:         'user',
      department:   curso.split('/').last,
      first_access: true,
      password:     SecureRandom.hex(16)
    )
  end

  def self.import_teacher(docente_data, turma)
    email = docente_data['email']
    User.find_by(email: email) || create_teacher(docente_data, email, turma)
  end
  def self.import_teacher(docente_data, turma)
    email = docente_data['email']
    User.find_by(email: email) || create_teacher(docente_data, email, turma)
  end

  def self.create_teacher(docente_data, email, turma)
    User.create!(
      matricula:    docente_data['usuario'],
      name:         docente_data['nome'],
      email:        email,
      role:         'admin',
      department:   turma.disciplina.department,
      first_access: true,
      password:     SecureRandom.hex(16)
    )
  def self.create_teacher(docente_data, email, turma)
    User.create!(
      matricula:    docente_data['usuario'],
      name:         docente_data['nome'],
      email:        email,
      role:         'admin',
      department:   turma.disciplina.department,
      first_access: true,
      password:     SecureRandom.hex(16)
    )
  end
end









