from flask import Flask, request, jsonify
from pyswip import Prolog

app = Flask(__name__)

# Charger le fichier Prolog
prolog_file = Prolog()
prolog_file.consult("testdsfin.pl")

import json

def handle_bytes(obj):
    if isinstance(obj, bytes):
        return obj.decode('utf-8')
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

@app.route('/api/recommandation', methods=['POST'])
def recommandation():
    try:
        data = request.json
        preferences = data.get('preferences')
        budget = data.get('budget')
        climat = data.get('climat')
        acces = data.get('acces')

        # Vérifier si toutes les données sont entrer cad dans le request
        if not all([preferences, budget, climat, acces]):
            return jsonify({'error': 'Données incomplètes'}), 400
        
        # Exécuter la requête Prolog
        query = list(prolog_file.query(f"recommander_par_criteres('{preferences[0]}', '{preferences[1]}', {budget}, '{climat}', Destination)"))

        # Vérifier la réponse de la requête
        if query:
            recommendations = []

            #on parcours le resultat de la requete qui se trouve dans query
            for result in query:   
                destination = result['Destination']
                #recuperer les details du lieu
                details = list(prolog_file.query(f"lieu('{destination}', Activites, Budget, Climat, Accessibilite, Note, Prix)"))[0]
                #recuperation des details du restaurant correspondant a la destination
                restaurants = list(prolog_file.query(f"restaurant('{destination}', Restaurants)"))[0]['Restaurants']
                # detail de l'itineraire a suivre pour la destination
                itineraire = list(prolog_file.query(f"itineraire('{destination}', Itineraire)"))[0]['Itineraire']

                recommendation = {
                    'destination': destination,
                    'activites': details['Activites'],
                    'budget': details['Budget'],
                    'climat': details['Climat'],
                    'accessibilite': details['Accessibilite'],
                    'note': details['Note'],
                    'prix_moyen_par_jour': details['Prix'],
                    'restaurants': restaurants,
                    'itineraire_recommande': itineraire
                }
                recommendations.append(recommendation)

            # Convertir les recommandations en JSON en gérant les bytes
            response_json = json.dumps({'recommandations': recommendations}, default=handle_bytes)
            return response_json, 200, {'Content-Type': 'application/json'}
        else:
            return jsonify({'error': 'Aucune recommandation trouvée'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)