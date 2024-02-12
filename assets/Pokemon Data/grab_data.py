import requests
import csv

# Function to get Pokemon data
def get_pokemon_data(pokemon_id):
    response = requests.get(f"https://pokeapi.co/api/v2/pokemon/{pokemon_id}")
    if response.status_code == 200:
        return response.json()
    else:
        return None
    
# Function to get move data
def get_move_data(move_id):
    response = requests.get(f"https://pokeapi.co/api/v2/move/{move_id}")
    if response.status_code == 200:
        return response.json()
    else:
        return None

# Prepare CSV file for Pokemon Data
pokemon_data_csv = 'Gen1_Pokemon_Data.csv'
pokemon_data_fieldnames = ['ID', 'Name', 'Height', 'Weight', 'Types', 'Abilities', 'Stats']

# Prepare CSV file for Move data
move_data_csv = 'Pokemon_Moves_Data.csv'
move_data_fieldnames = ['ID', 'Name', 'Accuracy', 'Effect Chance', 'PP', 'Priority', 'Power', 'Type', 'Damage Class']

with open(pokemon_data_csv, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=pokemon_data_fieldnames)
    writer.writeheader()

    # Fetch and write data for each Pokemon in Generation 1
    for pokemon_id in range(1, 387):
        data = get_pokemon_data(pokemon_id)
        if data:
            # Process types
            types = [t['type']['name'] for t in data['types']]
            # Process abilities
            abilities = [a['ability']['name'] for a in data['abilities']]
            # Process stats
            stats = {s['stat']['name']: s['base_stat'] for s in data['stats']}

            # Write row to CSV
            writer.writerow({
                'ID': data['id'],
                'Name': data['name'],
                'Height': data['height'],
                'Weight': data['weight'],
                'Types': ', '.join(types),
                'Abilities': ', '.join(abilities),
                'Stats': stats
            })

with open(move_data_csv, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=move_data_fieldnames)
    writer.writeheader()

    # Fetch and write data for each Move
    # Adjust the range as per the total number of moves available in the API
    for move_id in range(1, 10):  # Example range, might need to be adjusted
        data = get_move_data(move_id)
        if data:
            writer.writerow({
                'ID': data['id'],
                'Name': data['name'],
                'Accuracy': data['accuracy'],
                'Effect Chance': data.get('effect_chance'),
                'PP': data['pp'],
                'Priority': data['priority'],
                'Power': data['power'],
                'Type': data['type']['name'],
                'Damage Class': data['damage_class']['name']
            })

print(f"Data written to {pokemon_data_csv} {move_data_csv}")
