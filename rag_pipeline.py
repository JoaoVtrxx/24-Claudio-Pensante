import json
import pandas as pd
import numpy as np
from sentence_transformers import SentenceTransformer
import faiss
from typing import List, Dict, Any, Tuple
import pickle
import os

class FitnessNutritionRAG:
    def __init__(self, json_path: str, csv_path: str, model_name: str = 'sentence-transformers/all-MiniLM-L6-v2'):
        """
        Initialize the RAG system for fitness and nutrition data
        
        Args:
            json_path: Path to fitness knowledge base JSON
            csv_path: Path to food database CSV
            model_name: Name of the sentence transformer model
        """
        self.json_path = json_path
        self.csv_path = csv_path
        self.model = SentenceTransformer(model_name)
        
        # Load data
        self.fitness_data = self._load_fitness_data()
        self.food_data = self._load_food_data()
        
        # Create knowledge base chunks
        self.knowledge_chunks = []
        self.chunk_embeddings = None
        self.faiss_index = None
        
        # Initialize the system
        self._create_knowledge_chunks()
        self._create_embeddings()
        self._build_faiss_index()
    
    def _load_fitness_data(self) -> Dict[str, Any]:
        """Load fitness knowledge base from JSON"""
        with open(self.json_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    
    def _load_food_data(self) -> pd.DataFrame:
        """Load food database from CSV"""
        return pd.read_csv(self.csv_path, sep=';')
    
    def _create_knowledge_chunks(self):
        """Create searchable chunks from fitness knowledge base and food data"""
        
        # Process fitness knowledge base
        self._process_formulas()
        self._process_nutrients()
        self._process_training_zones()
        self._process_body_composition()
        self._process_supplements()
        self._process_timing_protocols()
        self._process_individual_factors()
        
        # Process food database
        self._process_food_database()
    
    def _process_formulas(self):
        """Process BMR formulas and activity multipliers"""
        formulas = self.fitness_data.get('formulas', {})
        
        # BMR equations
        bmr_equations = formulas.get('bmr_equations', {})
        for equation_name, details in bmr_equations.items():
            chunk = {
                'type': 'formula',
                'category': 'bmr',
                'name': equation_name,
                'content': f"Fórmula {equation_name}: {details}",
                'data': details
            }
            self.knowledge_chunks.append(chunk)
        
        # Activity multipliers
        activity_mult = formulas.get('activity_multipliers', {})
        chunk = {
            'type': 'formula',
            'category': 'activity',
            'name': 'multiplicadores_atividade',
            'content': f"Multiplicadores de atividade física: {activity_mult}",
            'data': activity_mult
        }
        self.knowledge_chunks.append(chunk)
        
        # Calorie adjustments
        calorie_adj = formulas.get('calorie_adjustments', {})
        for goal, details in calorie_adj.items():
            chunk = {
                'type': 'formula',
                'category': 'calorie_adjustment',
                'name': goal,
                'content': f"Ajuste calórico para {goal}: {details}",
                'data': details
            }
            self.knowledge_chunks.append(chunk)
    
    def _process_nutrients(self):
        """Process nutrient information"""
        nutrients = self.fitness_data.get('nutrients', {})
        for nutrient_name, details in nutrients.items():
            chunk = {
                'type': 'nutrient',
                'category': 'micronutrient',
                'name': nutrient_name,
                'content': f"Nutriente {details['name']}: RDA masculino {details.get('rda_male', 'N/A')}, "
                          f"RDA feminino {details.get('rda_female', 'N/A')}, "
                          f"Fontes: {', '.join(details.get('food_sources', []))}, "
                          f"Sintomas de deficiência: {', '.join(details.get('deficiency_symptoms', []))}, "
                          f"Notas de interação: {details.get('interaction_notes', '')}",
                'data': details
            }
            self.knowledge_chunks.append(chunk)
    
    def _process_training_zones(self):
        """Process training zones information"""
        zones = self.fitness_data.get('training_zones', [])
        for zone in zones:
            chunk = {
                'type': 'training',
                'category': 'zone',
                'name': f"zona_{zone.get('zone', '')}",
                'content': f"Zona {zone.get('zone', '')}: {zone.get('name', '')}, "
                          f"FC: {zone.get('hr_percentage', [])}, "
                          f"RPE: {zone.get('rpe_scale', [])}, "
                          f"Substrato: {zone.get('primary_substrate', '')}, "
                          f"Foco nutricional: {', '.join(zone.get('nutrition_focus', []))}, "
                          f"Tempo de recuperação: {zone.get('recovery_time', '')}",
                'data': zone
            }
            self.knowledge_chunks.append(chunk)
    
    def _process_body_composition(self):
        """Process body composition information"""
        body_comp = self.fitness_data.get('body_composition', {})
        
        # Body fat categories
        bf_categories = body_comp.get('body_fat_categories', {})
        for gender, categories in bf_categories.items():
            chunk = {
                'type': 'body_composition',
                'category': 'body_fat',
                'name': f"gordura_corporal_{gender}",
                'content': f"Categorias de gordura corporal para {gender}: {categories}",
                'data': categories
            }
            self.knowledge_chunks.append(chunk)
        
        # Metabolic adjustments
        met_adj = body_comp.get('metabolic_adjustments', {})
        for category, adjustments in met_adj.items():
            chunk = {
                'type': 'body_composition',
                'category': 'metabolic_adjustment',
                'name': category,
                'content': f"Ajustes metabólicos para {category}: {adjustments}",
                'data': adjustments
            }
            self.knowledge_chunks.append(chunk)
    
    def _process_supplements(self):
        """Process supplement information"""
        supplements = self.fitness_data.get('supplements', {})
        for tier, supps in supplements.items():
            for supp_name, details in supps.items():
                chunk = {
                    'type': 'supplement',
                    'category': tier,
                    'name': supp_name,
                    'content': f"Suplemento {supp_name} (Tier {tier}): "
                              f"Dosagem: {details.get('dosage', '')}, "
                              f"Timing: {details.get('timing', '')}, "
                              f"Benefícios: {', '.join(details.get('benefits', []))}, "
                              f"Evidência: {details.get('evidence_grade', '')}",
                    'data': details
                }
                self.knowledge_chunks.append(chunk)
    
    def _process_timing_protocols(self):
        """Process nutrient timing protocols"""
        timing = self.fitness_data.get('timing_protocols', {})
        for protocol_name, details in timing.items():
            chunk = {
                'type': 'timing',
                'category': 'protocol',
                'name': protocol_name,
                'content': f"Protocolo {protocol_name}: {details}",
                'data': details
            }
            self.knowledge_chunks.append(chunk)
    
    def _process_individual_factors(self):
        """Process individual factors (genetics, sex, age, training)"""
        factors = self.fitness_data.get('individual_factors', {})
        for factor_type, details in factors.items():
            chunk = {
                'type': 'individual_factor',
                'category': factor_type,
                'name': factor_type,
                'content': f"Fatores individuais - {factor_type}: {details}",
                'data': details
            }
            self.knowledge_chunks.append(chunk)
    
    def _process_food_database(self):
        """Process food database into searchable chunks"""
        for _, row in self.food_data.iterrows():
            # Clean and format food data
            food_name = row['Descrição dos alimentos']
            category = row['Categoria do alimento']
            energy = row['Energia (kcal)']
            protein = row['Proteína (g)']
            carbs = row['Carboidrato (g)']
            fat = row['Lipídeos (g)']
            fiber = row['Fibra Alimentar (g)']
            
            chunk = {
                'type': 'food',
                'category': category,
                'name': food_name,
                'content': f"Alimento: {food_name}, Categoria: {category}, "
                          f"Energia: {energy} kcal, Proteína: {protein}g, "
                          f"Carboidrato: {carbs}g, Gordura: {fat}g, "
                          f"Fibra: {fiber}g",
                'data': row.to_dict()
            }
            self.knowledge_chunks.append(chunk)
    
    def _create_embeddings(self):
        """Create embeddings for all knowledge chunks"""
        texts = [chunk['content'] for chunk in self.knowledge_chunks]
        self.chunk_embeddings = self.model.encode(texts)
    
    def _build_faiss_index(self):
        """Build FAISS index for similarity search"""
        dimension = self.chunk_embeddings.shape[1]
        self.faiss_index = faiss.IndexFlatIP(dimension)  # Inner product for cosine similarity
        
        # Normalize embeddings for cosine similarity
        faiss.normalize_L2(self.chunk_embeddings)
        self.faiss_index.add(self.chunk_embeddings.astype('float32'))
    
    def search_similar(self, query: str, k: int = 10) -> List[Dict[str, Any]]:
        """
        Search for similar chunks based on query
        
        Args:
            query: Search query
            k: Number of similar chunks to return
            
        Returns:
            List of similar chunks with scores
        """
        query_embedding = self.model.encode([query])
        faiss.normalize_L2(query_embedding)
        
        scores, indices = self.faiss_index.search(query_embedding.astype('float32'), k)
        
        results = []
        for i, (score, idx) in enumerate(zip(scores[0], indices[0])):
            chunk = self.knowledge_chunks[idx].copy()
            chunk['similarity_score'] = float(score)
            chunk['rank'] = i + 1
            results.append(chunk)
        
        return results
    
    def create_diet_prompt(self, user_query: str, user_data: Dict[str, Any]) -> str:
        """
        Create a comprehensive prompt for diet planning
        
        Args:
            user_query: User's question or request
            user_data: User's personal data (weight, body fat, activity level, etc.)
            
        Returns:
            Enhanced prompt with relevant context
        """
        # Search for relevant information
        relevant_chunks = self.search_similar(user_query, k=15)
        
        # Separate different types of information
        formulas = [c for c in relevant_chunks if c['type'] == 'formula']
        nutrients = [c for c in relevant_chunks if c['type'] == 'nutrient']
        foods = [c for c in relevant_chunks if c['type'] == 'food']
        supplements = [c for c in relevant_chunks if c['type'] == 'supplement']
        timing = [c for c in relevant_chunks if c['type'] == 'timing']
        individual_factors = [c for c in relevant_chunks if c['type'] == 'individual_factor']
        
        # Build the enhanced prompt
        enhanced_prompt = f"""
# SISTEMA DE PLANEJAMENTO NUTRICIONAL PERSONALIZADO

## DADOS DO USUÁRIO:
{json.dumps(user_data, indent=2, ensure_ascii=False)}

## SOLICITAÇÃO DO USUÁRIO:
{user_query}

## CONTEXTO CIENTÍFICO RELEVANTE:

### FÓRMULAS E CÁLCULOS METABÓLICOS:
{self._format_chunks(formulas[:3])}

### INFORMAÇÕES NUTRICIONAIS:
{self._format_chunks(nutrients[:4])}

### ALIMENTOS DISPONÍVEIS:
{self._format_chunks(foods[:5])}

### SUPLEMENTAÇÃO:
{self._format_chunks(supplements[:2])}

### TIMING NUTRICIONAL:
{self._format_chunks(timing[:2])}

### FATORES INDIVIDUAIS:
{self._format_chunks(individual_factors[:2])}

## INSTRUÇÕES PARA O AGENTE:

Você é um nutricionista especializado em performance e composição corporal. Sua função é:

1. **ANÁLISE PERSONALIZADA**: Analise os dados do usuário (peso, gordura corporal, nível de atividade, restrições alimentares, objetivos) para criar um plano nutricional personalizado.

2. **CÁLCULOS METABÓLICOS**: 
   - Calcule o TMB usando as fórmulas apropriadas
   - Determine o gasto energético total considerando o nível de atividade
   - Ajuste as calorias conforme o objetivo (déficit, superávit ou manutenção)

3. **DISTRIBUIÇÃO DE MACRONUTRIENTES**:
   - Estabeleça as necessidades de proteína baseadas no peso e objetivo
   - Calcule carboidratos conforme o nível de atividade e timing
   - Determine gorduras para otimização hormonal

4. **SELEÇÃO DE ALIMENTOS**:
   - Use APENAS alimentos da base de dados TACO fornecida
   - Priorize alimentos densos nutricionalmente
   - Considere preferências e restrições alimentares

5. **TIMING E FREQUÊNCIA**:
   - Distribua as refeições otimamente ao longo do dia
   - Considere timing pré/pós treino se aplicável
   - Ajuste conforme rotina do usuário

6. **SUPLEMENTAÇÃO** (se necessário):
   - Recomende apenas suplementos tier 1 ou 2 se houver lacunas nutricionais
   - Explique dosagem e timing

7. **MONITORAMENTO**:
   - Estabeleça métricas de acompanhamento
   - Sugira ajustes conforme progresso

## FORMATO DA RESPOSTA:

Forneça um plano estruturado contendo:
- Resumo dos cálculos metabólicos
- Distribuição de macronutrientes
- Cardápio detalado com quantidades
- Orientações de timing
- Recomendações de suplementação (se aplicável)
- Estratégias de monitoramento

**IMPORTANTE**: Use apenas alimentos da base TACO e seja específico com quantidades e horários.
"""

        return enhanced_prompt
    
    def _format_chunks(self, chunks: List[Dict[str, Any]]) -> str:
        """Format chunks for inclusion in prompt"""
        if not chunks:
            return "Nenhuma informação relevante encontrada."
        
        formatted = []
        for chunk in chunks:
            formatted.append(f"- {chunk['name']}: {chunk['content'][:200]}...")
        
        return "\n".join(formatted)
    
    def get_food_recommendations(self, criteria: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Get food recommendations based on specific criteria
        
        Args:
            criteria: Dictionary with nutritional criteria
            
        Returns:
            List of recommended foods
        """
        # Filter foods based on criteria
        filtered_foods = []
        
        for chunk in self.knowledge_chunks:
            if chunk['type'] == 'food':
                food_data = chunk['data']
                
                # Apply filters
                if self._meets_criteria(food_data, criteria):
                    filtered_foods.append(chunk)
        
        return filtered_foods[:10]  # Return top 10
    
    def _meets_criteria(self, food_data: Dict[str, Any], criteria: Dict[str, Any]) -> bool:
        """Check if food meets specified criteria"""
        try:
            # Example criteria checking
            if 'min_protein' in criteria:
                protein = float(str(food_data.get('Proteína (g)', 0)).replace(',', '.'))
                if protein < criteria['min_protein']:
                    return False
            
            if 'max_carbs' in criteria:
                carbs = float(str(food_data.get('Carboidrato (g)', 0)).replace(',', '.'))
                if carbs > criteria['max_carbs']:
                    return False
            
            if 'category' in criteria:
                if food_data.get('Categoria do alimento') != criteria['category']:
                    return False
            
            return True
        except (ValueError, TypeError):
            return False
    
    def save_index(self, filepath: str):
        """Save FAISS index and chunks to disk"""
        faiss.write_index(self.faiss_index, f"{filepath}.faiss")
        
        with open(f"{filepath}_chunks.pkl", 'wb') as f:
            pickle.dump(self.knowledge_chunks, f)
        
        with open(f"{filepath}_embeddings.pkl", 'wb') as f:
            pickle.dump(self.chunk_embeddings, f)
    
    def load_index(self, filepath: str):
        """Load FAISS index and chunks from disk"""
        if os.path.exists(f"{filepath}.faiss"):
            self.faiss_index = faiss.read_index(f"{filepath}.faiss")
            
            with open(f"{filepath}_chunks.pkl", 'rb') as f:
                self.knowledge_chunks = pickle.load(f)
            
            with open(f"{filepath}_embeddings.pkl", 'rb') as f:
                self.chunk_embeddings = pickle.load(f)
            
            return True
        return False


# Example usage
if __name__ == "__main__":
    # Initialize RAG system
    rag = FitnessNutritionRAG(
        json_path="fitness_knowledge_base.json",
        csv_path="taco-main/tabelas/alimentos.csv"
    )
    
    # Example user data
    user_data = {
        "peso_kg": 70,
        "altura_cm": 175,
        "idade": 30,
        "sexo": "masculino",
        "gordura_corporal_pct": 15,
        "nivel_atividade": "moderate_activity",
        "objetivo": "muscle_gain",
        "restricoes_alimentares": [],
        "preferencias": "sem preferências específicas"
    }
    
    # Example query
    user_query = "Preciso de um plano alimentar para ganho de massa muscular"
    
    # Create enhanced prompt
    enhanced_prompt = rag.create_diet_prompt(user_query, user_data)
    
    # Save prompt to file
    output_file = "enhanced_prompt_output.txt"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("=== PROMPT APRIMORADO PARA LLM ===\n\n")
        f.write(enhanced_prompt)
        f.write("\n\n=== RECOMENDAÇÕES DE ALIMENTOS RICOS EM PROTEÍNA ===\n")
        
        # Example: Get high-protein food recommendations
        protein_criteria = {"min_protein": 15, "category": "Carnes e derivados"}
        protein_foods = rag.get_food_recommendations(protein_criteria)
        
        for food in protein_foods[:5]:
            f.write(f"- {food['name']}: {food['data']['Proteína (g)']}g proteína\n")
    
    print(f"Prompt salvo no arquivo: {output_file}")
    print(f"Total de chunks de conhecimento criados: {len(rag.knowledge_chunks)}")
    print(f"Dimensão dos embeddings: {rag.chunk_embeddings.shape}")
