import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { extname } from 'path';

@Injectable()
export class UploadService {
  private supabase: SupabaseClient;
  private bucketName = process.env.SUPABASE_BUCKET || 'abc-do-bem-bucket';

  constructor() {
    this.supabase = createClient(
      process.env.SUPABASE_URL || 'https://placeholder.supabase.co',
      process.env.SUPABASE_KEY || 'placeholder_key'
    );
  }

  async uploadFile(file: Express.Multer.File, folder: string = 'geral'): Promise<string> {
    try {
      const fileExt = extname(file.originalname);
      // Gera um nome único: timestamp-numeroAleatorio.extensao
      const fileName = `${Date.now()}-${Math.round(Math.random() * 1e9)}${fileExt}`;
      const filePath = `${folder}/${fileName}`;

      const { error } = await this.supabase.storage
        .from(this.bucketName)
        .upload(filePath, file.buffer, {
          contentType: file.mimetype,
          upsert: false,
        });

      if (error) throw error;

      // Retorna a URL pública gerada
      const { data: publicUrlData } = this.supabase.storage
        .from(this.bucketName)
        .getPublicUrl(filePath);

      return publicUrlData.publicUrl;
    } catch (error) {
      console.error('Erro no Supabase:', error);
      throw new InternalServerErrorException('Erro ao fazer upload da imagem.');
    }
  }
}