module MessageHelper
  # Transforme un JSON en cours de génération en aperçu lisible
  def streaming_preview(jsonish)
    text = jsonish.to_s

    # 1) Si on détecte "notes": "...  → on affiche les notes en clair
    if (m = text.match(/"notes"\s*:\s*"([^"]*)/m))
      return m[1].gsub(/\\n/, "\n").gsub(/\\"/, '"')
    end

    # 2) Sinon, si on voit des noms d'activités, on en fait une courte liste
    names = text.scan(/"name"\s*:\s*"([^"]+)"/).flatten
    if names.any?
      return "Processing...\n" + names.uniq.take(10).map { |n| "• #{n}" }.join("\n")
    end

    # 3) Fallback : "débruiter" le JSON partiel pour le rendre lisible
    text.gsub(/[\{\}\[\]]/, '')
        .gsub(/"(\w+)"\s*:\s*/,'\1: ')
        .gsub(/",\s*/,"\"\n")
        .gsub(/\\n/, "\n")
        .gsub(/\\"/, '"')
  end
end
