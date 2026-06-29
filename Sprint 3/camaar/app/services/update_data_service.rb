# Responsável por atualizar os dados das disciplinas,
# turmas e usuários a partir dos arquivos JSON fornecidos.
class UpdateDataService

  CLASSES_PATH = Rails.root.join('..', '..', 'classes.json').freeze
  MEMBERS_PATH = Rails.root.join('..', '..', 'class_members.json').freeze

  def self.update_all
    return arquivos_ausentes unless files_exist?

    classes_data, members_data = load_json_files
    updated_records = contar_atualizacoes(classes_data, members_data)

    success_response(updated_records)
  rescue JSON::ParserError
    { success: false, error: 'Erro ao ler os arquivos JSON' }
  end

  private

  def self.contar_atualizacoes(classes_data, members_data)
    update_disciplinas_classes(classes_data) +
      update_users_members(members_data)
  end

  def self.update_disciplinas_classes(classes_data)
    classes_data.sum do |class_data|
      update_disciplina(class_data) + update_turma(class_data)
    end
  end

  def self.update_users_members(members_data)
    members_data.sum do |member_data|
      update_dicentes(member_data) + update_docente(member_data)
    end
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

  def self.success_response(updated_records)
    if updated_records.zero?
      { success: true, updated: false, message: 'Não há novos dados para atualização' }
    else
      { success: true, updated: true,  message: 'Dados atualizados com sucesso' }
    end
  end


  def self.update_disciplina(class_data)
    codigo     = class_data['code']
    disciplina = Disciplina.find_or_initialize_by(codigo: codigo)
    disciplina.assign_attributes(
      nome:       class_data['name'],
      department: codigo.gsub(/[0-9]/, '').strip
    )
    save_if_changed(disciplina)
  end

  def self.update_turma(class_data)
    turma_info = class_data['class']
    disciplina = Disciplina.find_by(codigo: class_data['code'])
    turma      = Turma.find_or_initialize_by(
      codigo:     turma_info['classCode'],
      semestre:   turma_info['semester'],
      disciplina: disciplina
    )
    turma.assign_attributes(horario: turma_info['time'])
    save_if_changed(turma)
  end

  def self.update_dicentes(member_data)
    (member_data['dicente'] || []).sum { |aluno_data| update_dicente(aluno_data) }
  end

  def self.update_dicente(aluno_data)
    user = User.find_by(matricula: aluno_data['matricula'])
    return 0 unless user

    curso = aluno_data['curso'] || ''
    user.assign_attributes(
      name:       aluno_data['nome'],
      email:      aluno_data['email']&.downcase,
      department: curso.split('/').last
    )
    save_if_changed(user)
  end

  def self.update_docente(member_data)
    docente = member_data['docente']
    return 0 unless docente

    user = User.find_by(matricula: docente['usuario'])
    return 0 unless user

    user.assign_attributes(
      name:  docente['nome'],
      email: docente['email']&.downcase
    )
    save_if_changed(user)
  end

  def self.save_if_changed(record)
    return 0 unless record.new_record? || record.changed?

    record.save!
    1
  end
end