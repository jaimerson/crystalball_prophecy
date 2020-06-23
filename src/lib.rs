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

            match related_examples {
                Some(examples) => {
                    for example in examples.iter(){
                        result.push(self.encoder.decode(example));
                    }
                    result.join(",")
                },
                None => String::new()
            }
        }

        // Assumes both example and related_files are already encoded
        def set_encoded(&mut self, example: String, related_files: String){
            let files: Vec<&str> = related_files.split(",").collect();
            let mut result: Vec<String> = vec![];

            for file in files.iter(){
                result.push(file.to_string())
            }

            self.example_groups.insert(example, result);
        }

        def set_dictionary(&mut self, values_to_store: String){
            self.encoder.set_stored_values(&values_to_store);
        }

        def affected_examples_for(&mut self, files: String) -> String{
            let mut result: Vec<String> = vec![];
            let files_list: Vec<&str> = files.split(",").collect();

            for file in files_list.iter(){
                let encoded_file_path = self.encoder.encode(&file);
                let related_examples = self.example_groups.get(&encoded_file_path);

                match related_examples {
                    Some(examples) => {
                        for example in examples.iter(){
                            let decoded_example = self.encoder.decode(example);
                            if !result.contains(&decoded_example){
                                result.push(decoded_example);
                            }
                        }
                    },
                    None => ()
                }
            }
            result.join(",")
        }

        def examples(&mut self) -> String{
            let mut result: Vec<String> = vec![];
            for examples_list in self.example_groups.values(){
                for example in examples_list.iter(){
                    let decoded_example = self.encoder.decode(&example.to_string());
                    if !result.contains(&decoded_example){
                        result.push(decoded_example);
                    }
                }
            }
            result.join(",")
        }

        def example_groups(&mut self) -> String{
            let mut result: Vec<String> = vec![];
            for (file, examples) in self.example_groups.iter(){
                let decoded_file = self.encoder.decode(&file.to_string());
                let mut line: Vec<String> = vec![];
                line.push(decoded_file);
                for example in examples.iter(){
                    let decoded_example = self.encoder.decode(&example.to_string());
                    line.push(decoded_example);
                }
                result.push(line.join(","));
            }
            result.join(";")
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

        def clear(&mut self){
            self.example_groups.clear();
        }

        def print_example_groups(&self){
            println!("Example groups: {:?}", self.example_groups);
        }
    }
}
