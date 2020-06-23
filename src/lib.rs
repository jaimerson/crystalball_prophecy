#[macro_use]
extern crate helix;

use std::collections::HashMap;

mod types;

ruby! {
    class CrystalballProphecyDataSource {
        struct {
            encoder: types::PathEncoder,
            example_groups: HashMap<String, Vec<String>>
        }

        def initialize(helix){
            let encoder = types::PathEncoder::new();
            let example_groups = HashMap::new();

            CrystalballProphecyDataSource { helix, encoder: encoder, example_groups: example_groups }
        }

        def set(&mut self, example: String, related_files: String){
            let files: Vec<&str> = related_files.split(",").collect();
            let encoded_example_path = self.encoder.encode(&example);

            for file in files.iter() {
                let encoded_file_path = self.encoder.encode(file);
                self.example_groups.entry(encoded_file_path)
                    .and_modify(|e| e.push(encoded_example_path.to_string()))
                    .or_insert(vec![encoded_example_path.to_string()]);
            }
        }

        def get(&mut self, file_path: String) -> String{
            let encoded_file_path = self.encoder.encode(&file_path);
            let related_examples = self.example_groups.get(&encoded_file_path);
            let mut result: Vec<String> = vec![];

            for example in related_examples.unwrap().iter(){
                result.push(self.encoder.decode(example));
            }
            result.join(",")
        }

        def size(&self) -> usize{
            self.example_groups.len()
        }

        def keys(&mut self) -> String{
            let mut result: Vec<String> = vec![];
            for key in self.example_groups.keys(){
                let decoded_key = self.encoder.decode(key);
                result.push(decoded_key);
            }
            result.join(",")
        }

        def print_example_groups(&self){
            println!("Example groups: {:?}", self.example_groups);
        }
    }
}
