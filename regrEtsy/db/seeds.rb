Category.create!([
  {name: "Time Machines"},
  {name: "Pharmaceuticals"},
  {name: "Personal Care"},
  {name: "Lifestyle"}
])
User.create!([
  {name: nil, username: "Jane Doe", email: nil, password: "verysecure", uid: nil, provider: nil}
])
Product.create!([
  {name: "Kat Von D Tattoo Concealer ", description: "A highly-pigmented, full-coverage, transfer- and water-resistant concealer. ", price: 25.0, stock: 3, url: "https://www.amazon.com/Kat-Von-Lock-Tattoo-Concealer/dp/B00HC2IYDE", user_id: nil, retired: false},
  {name: "Aspirin", description: "Pill for hangover", price: 14.99, stock: 5, url: "", user_id: nil, retired: false},
  {name: "Aspirin", description: "Pill for hangover", price: 14.99, stock: 5, url: "", user_id: nil, retired: false},
  {name: "Walk of Shame Carpet", description: "You know you want it", price: 1700.0, stock: 1, url: "", user_id: nil, retired: false},
  {name: "Plan B", description: "", price: 27.49, stock: 5, url: "", user_id: nil, retired: false},
  {name: "White Out", description: "", price: 3.99, stock: 6, url: "", user_id: 1, retired: false},
  {name: "Tardis", description: "Dr. Who time machine", price: 2300000000.0, stock: 1, url: "https://cdn.pixabay.com/photo/2017/05/14/09/51/tardis-2311634_960_720.png", user_id: nil, retired: false}
])
