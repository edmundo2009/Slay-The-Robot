import json

files = ['navitime.json', 'scrape.json', 'trips.json', 'tripsfull.json']

for filename in files:
    path = f'_data_normalized/{filename}'
    try:
        data = json.load(open(path, encoding='utf-8'))
        qs = data if isinstance(data, list) else data.get('questions', data.get('cards', []))
        
        jpg_qs = [q for q in qs if 'question_image_url' in q and q.get('question_image_url') and '.jpg' in str(q.get('question_image_url'))]
        
        print(f'{filename}: {len(jpg_qs)} JPG references found')
        if jpg_qs:
            print(f'  Sample: {jpg_qs[0].get("question_image_url")}')
            print(f'  Question: {jpg_qs[0].get("question_text", "")[:60]}...')
    except Exception as e:
        print(f'{filename}: Error - {e}')
