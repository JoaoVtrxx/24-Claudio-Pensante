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
        
        # Separate fitness knowledge (static) from food chunks (RAG)
        self.fitness_knowledge = {}
        self.food_chunks = []
        self.food_embeddings = None
        self.faiss_index = None
        
        # Initialize the system
        self._extract_all_fitness_knowledge()
        self._create_food_chunks()
        self._create_food_embeddings()
        self._build_faiss_index()
    
    def _load_fitness_data(self) -> Dict[str, Any]:
        """Load fitness knowledge base from JSON"""
        if os.path.exists(self.json_path):
            with open(self.json_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        else:
            # Return empty dict if file doesn't exist
            return {}
    
    def _load_food_data(self) -> pd.DataFrame:
        """Load food database from CSV"""
        return pd.read_csv(self.csv_path, sep=';')
    
    def _extract_all_fitness_knowledge(self):
        """Extract all information from fitness knowledge base without chunking"""
        self.fitness_knowledge = {
            'formulas': self.fitness_data.get('formulas', {}),
            'nutrients': self.fitness_data.get('nutrients', {}),
            'training_zones': self.fitness_data.get('training_zones', []),
            'body_composition': self.fitness_data.get('body_composition', {}),
            'supplements': self.fitness_data.get('supplements', {}),
            'timing_protocols': self.fitness_data.get('timing_protocols', {}),
            'individual_factors': self.fitness_data.get('individual_factors', {}),
            'dietary_guidelines': self.fitness_data.get('dietary_guidelines', {}),
            'hydration': self.fitness_data.get('hydration', {}),
            'meal_timing': self.fitness_data.get('meal_timing', {}),
            'special_populations': self.fitness_data.get('special_populations', {}),
            'metabolic_conditions': self.fitness_data.get('metabolic_conditions', {}),
            'performance_nutrition': self.fitness_data.get('performance_nutrition', {}),
            'recovery_nutrition': self.fitness_data.get('recovery_nutrition', {}),
            'micronutrient_interactions': self.fitness_data.get('micronutrient_interactions', {}),
            'food_safety': self.fitness_data.get('food_safety', {}),
            'cooking_methods': self.fitness_data.get('cooking_methods', {}),
            'portion_control': self.fitness_data.get('portion_control', {}),
            'weight_management': self.fitness_data.get('weight_management', {}),
            'sports_specific': self.fitness_data.get('sports_specific', {})
        }
    
    def _create_food_chunks(self):
        """Create searchable chunks only from food database"""
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
            self.food_chunks.append(chunk)
    
    def _create_food_embeddings(self):
        """Create embeddings only for food chunks"""
        if self.food_chunks:
            texts = [chunk['content'] for chunk in self.food_chunks]
            self.food_embeddings = self.model.encode(texts)
    
    def _build_faiss_index(self):
        """Build FAISS index only for food similarity search"""
        if self.food_embeddings is not None:
            dimension = self.food_embeddings.shape[1]
            self.faiss_index = faiss.IndexFlatIP(dimension)  # Inner product for cosine similarity
            
            # Normalize embeddings for cosine similarity
            faiss.normalize_L2(self.food_embeddings)
            self.faiss_index.add(self.food_embeddings.astype('float32'))
    
    def search_similar_foods(self, query: str, k: int = 10) -> List[Dict[str, Any]]:
        """
        Search for similar foods based on query using FAISS
        
        Args:
            query: Search query
            k: Number of similar foods to return
            
        Returns:
            List of similar food chunks with scores
        """
        if self.faiss_index is None or self.food_embeddings is None:
            return []
            
        query_embedding = self.model.encode([query])
        faiss.normalize_L2(query_embedding)
        
        scores, indices = self.faiss_index.search(query_embedding.astype('float32'), k)
        
        results = []
        for i, (score, idx) in enumerate(zip(scores[0], indices[0])):
            chunk = self.food_chunks[idx].copy()
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
        # Search for relevant foods using FAISS
        relevant_foods = self.search_similar_foods(user_query, k=10)
        
        # Build the enhanced prompt with all fitness knowledge + relevant foods
        enhanced_prompt = f"""
# SISTEMA DE PLANEJAMENTO NUTRICIONAL PERSONALIZADO

## DADOS DO USUÁRIO:
{json.dumps(user_data, indent=2, ensure_ascii=False)}

## SOLICITAÇÃO DO USUÁRIO:
{user_query}

## BASE DE CONHECIMENTO CIENTÍFICO:

### FÓRMULAS E CÁLCULOS METABÓLICOS:
{self._format_fitness_section('formulas')}

### INFORMAÇÕES NUTRICIONAIS:
{self._format_fitness_section('nutrients')}

### ZONAS DE TREINAMENTO:
{self._format_fitness_section('training_zones')}

### COMPOSIÇÃO CORPORAL:
{self._format_fitness_section('body_composition')}

### SUPLEMENTAÇÃO:
{self._format_fitness_section('supplements')}

### PROTOCOLOS DE TIMING NUTRICIONAL:
{self._format_fitness_section('timing_protocols')}

### FATORES INDIVIDUAIS:
{self._format_fitness_section('individual_factors')}

### DIRETRIZES DIETÉTICAS:
{self._format_fitness_section('dietary_guidelines')}

### HIDRATAÇÃO:
{self._format_fitness_section('hydration')}

### TIMING DAS REFEIÇÕES:
{self._format_fitness_section('meal_timing')}

### POPULAÇÕES ESPECIAIS:
{self._format_fitness_section('special_populations')}

### CONDIÇÕES METABÓLICAS:
{self._format_fitness_section('metabolic_conditions')}

### NUTRIÇÃO PARA PERFORMANCE:
{self._format_fitness_section('performance_nutrition')}

### NUTRIÇÃO PARA RECUPERAÇÃO:
{self._format_fitness_section('recovery_nutrition')}

### INTERAÇÕES DE MICRONUTRIENTES:
{self._format_fitness_section('micronutrient_interactions')}

### SEGURANÇA ALIMENTAR:
{self._format_fitness_section('food_safety')}

### MÉTODOS DE COCÇÃO:
{self._format_fitness_section('cooking_methods')}

### CONTROLE DE PORÇÕES:
{self._format_fitness_section('portion_control')}

### GERENCIAMENTO DE PESO:
{self._format_fitness_section('weight_management')}

### NUTRIÇÃO ESPECÍFICA POR ESPORTE:
{self._format_fitness_section('sports_specific')}

## ALIMENTOS RELEVANTES DA BASE TACO:
{self._format_food_chunks(relevant_foods)}

## INSTRUÇÕES PARA O AGENTE:

Você é um nutricionista especializado em performance e composição corporal. Sua função é:

1. **ANÁLISE PERSONALIZADA**: Analise os dados do usuário (peso, gordura corporal, nível de atividade, restrições alimentares, objetivos) para criar um plano nutricional personalizado.

2. **CÁLCULOS METABÓLICOS**: 
   - Calcule o TMB usando as fórmulas apropriadas da base de conhecimento
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
   - Explique dosagem e timing baseado nas informações da base de conhecimento

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
    
    def _format_fitness_section(self, section_name: str) -> str:
        """Format fitness knowledge sections"""
        section_data = self.fitness_knowledge.get(section_name, {})
        if not section_data:
            return "Não disponível na base de conhecimento."
        
        return json.dumps(section_data, indent=2, ensure_ascii=False)
    
    def _format_food_chunks(self, chunks: List[Dict[str, Any]]) -> str:
        """Format food chunks for inclusion in prompt"""
        if not chunks:
            return "Nenhum alimento relevante encontrado."
        
        formatted = []
        for chunk in chunks:
            formatted.append(f"- {chunk['name']}: {chunk['content']}")
        
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
        
        for chunk in self.food_chunks:
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
    
    def get_fitness_knowledge(self) -> Dict[str, Any]:
        """Get the complete fitness knowledge base"""
        return self.fitness_knowledge
    
    def save_index(self, filepath: str):
        """Save FAISS index and food chunks to disk"""
        if self.faiss_index:
            faiss.write_index(self.faiss_index, f"{filepath}.faiss")
        
        with open(f"{filepath}_food_chunks.pkl", 'wb') as f:
            pickle.dump(self.food_chunks, f)
        
        if self.food_embeddings is not None:
            with open(f"{filepath}_food_embeddings.pkl", 'wb') as f:
                pickle.dump(self.food_embeddings, f)
        
        with open(f"{filepath}_fitness_knowledge.pkl", 'wb') as f:
            pickle.dump(self.fitness_knowledge, f)
    
    def load_index(self, filepath: str):
        """Load FAISS index and chunks from disk"""
        try:
            if os.path.exists(f"{filepath}.faiss"):
                self.faiss_index = faiss.read_index(f"{filepath}.faiss")
            
            if os.path.exists(f"{filepath}_food_chunks.pkl"):
                with open(f"{filepath}_food_chunks.pkl", 'rb') as f:
                    self.food_chunks = pickle.load(f)
            
            if os.path.exists(f"{filepath}_food_embeddings.pkl"):
                with open(f"{filepath}_food_embeddings.pkl", 'rb') as f:
                    self.food_embeddings = pickle.load(f)
            
            if os.path.exists(f"{filepath}_fitness_knowledge.pkl"):
                with open(f"{filepath}_fitness_knowledge.pkl", 'rb') as f:
                    self.fitness_knowledge = pickle.load(f)
            
            return True
        except Exception as e:
            print(f"Erro ao carregar índices: {e}")
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
        f.write("\n\n=== ESTATÍSTICAS DO SISTEMA ===\n")
        f.write(f"Total de alimentos na base TACO: {len(rag.food_chunks)}\n")
        f.write(f"Seções da base de conhecimento fitness: {list(rag.fitness_knowledge.keys())}\n")
        
        # Example: Get high-protein food recommendations
        protein_criteria = {"min_protein": 15, "category": "Carnes e derivados"}
        protein_foods = rag.get_food_recommendations(protein_criteria)
        
        f.write("\n=== RECOMENDAÇÕES DE ALIMENTOS RICOS EM PROTEÍNA ===\n")
        for food in protein_foods[:5]:
            f.write(f"- {food['name']}: {food['data']['Proteína (g)']}g proteína\n")
    
    print(f"Prompt salvo no arquivo: {output_file}")
    print(f"Total de alimentos processados: {len(rag.food_chunks)}")
    print(f"Seções do conhecimento fitness extraídas: {len(rag.fitness_knowledge)}")
    if rag.food_embeddings is not None:
        print(f"Dimensão dos embeddings dos alimentos: {rag.food_embeddings.shape}")
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
