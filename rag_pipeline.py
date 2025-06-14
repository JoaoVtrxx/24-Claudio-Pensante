import pandas as pd
import os
from datetime import datetime

class NutritionRAGPipeline:
    def __init__(self):
        self.base_path = r"c:\Users\SAMSUNG\Desktop\Trabalhos\claudio-pensante"
        self.prompt_model_path = os.path.join(self.base_path, "prompt_model.txt")
        
        # Load the nutrition context
        self.load_nutrition_context()
    
    def load_nutrition_context(self):
        """Load the nutrition context from prompt_model.txt"""
        try:
            with open(self.prompt_model_path, 'r', encoding='utf-8') as f:
                self.nutrition_context = f.read()
        except FileNotFoundError:
            print(f"Warning: {self.prompt_model_path} not found. Using empty context.")
            self.nutrition_context = ""
    
    def generate_user_data_section(self, user_data):
        """Generate the user data section of the prompt"""
        user_section = "## DATA DO USUÁRIO\n\n"
        
        user_section += f"**Peso:** {user_data['peso']} kg\n"
        user_section += f"**Altura:** {user_data['altura']} cm\n"
        user_section += f"**Idade:** {user_data['idade']} years\n"
        user_section += f"**Sexo:** {user_data['sexo']}\n"
        user_section += f"**Localização:** {user_data['location']}\n\n"
        
        user_section += f"**Nível de atividade física:**\n{user_data['nivel_atividade_fisica']}\n\n"
        user_section += f"**Objetivo:**\n{user_data['objetivo']}\n\n"
        
        if user_data['alimentos_preferidos']:
            user_section += f"**Comidas preferidas:**\n"
            for item in user_data['alimentos_preferidos']:
                user_section += f"- {item}\n"
            user_section += "\n"
        
        if user_data['alimentos_indesejaveis']:
            user_section += f"**Alimentos indesejáveis para evitar:**\n"
            for item in user_data['alimentos_indesejaveis']:
                user_section += f"- {item}\n"
            user_section += "\n"
        
        return user_section
    
    def generate_complete_prompt(self, user_data):
        """Generate the complete prompt combining all sections"""
        # Build the complete prompt
        complete_prompt = "# PROMPT DE CONSULTA DE NUTRIÇÃO\n\n"
        complete_prompt += f"Data/Horário: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n"
        
        # Add user data section
        complete_prompt += self.generate_user_data_section(user_data)
        
        # Add nutrition context
        complete_prompt += self.nutrition_context
        complete_prompt += "\n\n"
        
        # Add final instructions
        complete_prompt += self._generate_final_instructions()
        
        return complete_prompt
    
    def _generate_final_instructions(self):
        """Generate final instructions for the AI"""
        instructions = "## INSTRUÇÕES PARA IA NUTRICIONISTA\n\n"
        instructions += "Com base nos dados do perfil do usuário acima, por favor:\n\n"
        instructions += "1. Calcule as necessidades nutricionais do usuário usando as fórmulas apropriadas do contexto nutricional\n"
        instructions += "2. Crie um plano alimentar personalizado considerando as preferências alimentares e restrições do usuário\n"
        instructions += "3. Certifique-se de que o plano atenda aos objetivos e requisitos do nível de atividade do usuário\n"
        instructions += "4. Considere a localização do usuário para disponibilidade de alimentos e preferências culturais\n"
        instructions += "5. Forneça recomendações específicas de tamanhos de porções e horários das refeições\n"
        instructions += "6. Inclua recomendações de suplementos se necessário com base nas diretrizes baseadas em evidências\n"
        instructions += "7. Explique a fundamentação por trás de suas recomendações\n\n"
        instructions += "Por favor, forneça um plano nutricional abrangente, prático e baseado em evidências."
        
        return instructions
    
    def save_prompt(self, complete_prompt, filename=None):
        """Save the complete prompt to a text file"""
        if filename is None:
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            filename = f"nutrition_prompt_{timestamp}.txt"
        
        filepath = os.path.join(self.base_path, filename)
        
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(complete_prompt)
            print(f"Prompt saved successfully to: {filepath}")
            return filepath
        except Exception as e:
            print(f"Error saving prompt: {e}")
            return None
        
def main():
    # Initialize the RAG pipeline
    pipeline = NutritionRAGPipeline()
    
    # Example user data - modify as needed
    user_data = {
        'peso': 75,  # kg
        'altura': 175,  # cm
        'idade': 30,  # years
        'sexo': 'Masculino',  # or 'Feminino'
        'location': 'Brasil',
        'nivel_atividade_fisica': 'Atividade moderada - treino de musculação 4x por semana, caminhada diária de 30 minutos',
        'objetivo': 'Ganho de massa muscular com redução de gordura corporal. Meta de aumentar 3kg de massa magra em 6 meses.',
        'alimentos_preferidos': ['frango', 'ovos', 'banana', 'aveia', 'Frutas e derivados'],
        'alimentos_indesejaveis': ['embutidos', 'fritura', 'açúcar refinado', 'refrigerante']
    }
    
    # Generate the complete prompt
    complete_prompt = pipeline.generate_complete_prompt(user_data)
    
    # Save to file
    filepath = pipeline.save_prompt(complete_prompt)
    
    if filepath:
        print("\nPrompt generation completed successfully!")
        print(f"File location: {filepath}")
        print(f"Prompt length: {len(complete_prompt)} characters")
    else:
        print("Failed to generate or save the prompt.")

if __name__ == "__main__":
    main()
