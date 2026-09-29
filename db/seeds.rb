# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cargando datos iniciales..."

# ============================================================
# USUARIO ADMINISTRADOR
# ============================================================

admin = User.find_or_initialize_by(email: "admin@utn.edu.ar")

admin.assign_attributes(
  name: "Admin UTN",
  password: "admin123",
  password_confirmation: "admin123",
  role: :admin,
  active: true
)

admin.save!

puts "Administrador listo: #{admin.email}"

# ============================================================
# USUARIO PERIODISTA
# ============================================================

journalist = User.find_or_initialize_by(email: "finoraapp@gmail.com")

journalist.assign_attributes(
  name: "Periodista",
  password: "periodista123",
  password_confirmation: "periodista123",
  role: :journalist,
  active: true
)

journalist.save!

puts "Periodista listo: #{journalist.email}"

# ============================================================
# CATEGORÍAS INICIALES
# ============================================================

[
  "Actualidad",
  "Deportes",
  "Tecnología",
  "Cultura"
].each do |category_name|
  Category.find_or_create_by!(name: category_name)
end

puts "Categorías listas."

puts "---------------------------------------"
puts "Datos iniciales cargados correctamente."
puts
puts "Administrador:"
puts "  Email: admin@utn.edu.ar"
puts "  Password: admin123"
puts
puts "Periodista:"
puts "  Email: finoraapp@gmail.com"
puts "  Password: periodista123"
puts "---------------------------------------"
