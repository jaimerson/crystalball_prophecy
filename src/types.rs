#[derive(Clone, Debug)]
pub struct PathEncoder {
    pub stored_values: Vec<String>,
}

impl PathEncoder {
    pub fn new() -> PathEncoder {
        PathEncoder {
            stored_values: Vec::new(),
        }
    }

    // Stores all words in vector and returns encoded string
    pub fn encode(&mut self, path: &str) -> String {
        let words: Vec<&str> = path.split("/").collect();
        let mut result: Vec<String> = vec![];

        for word in words.iter() {
            result.push(self.encode_word(word.to_string()));
        }
        result.join("/")
    }

    pub fn decode(&mut self, path: &str) -> String {
        let words: Vec<&str> = path.split("/").collect();
        let mut result: Vec<String> = vec![];

        for word in words.iter() {
            let decoded_word = self.decode_word(word.parse::<usize>().unwrap());
            match decoded_word {
                Some(word) => result.push(word),
                None => println!("Word not yet encoded! {:?}", word),
            }
        }
        result.join("/")
    }

    pub fn set_stored_values(&mut self, values: &str) {
        self.stored_values.clear();

        for value in values.split(",") {
            self.stored_values.push(value.to_string());
        }
    }

    // If the word is already stored, returns string representation of its index. If not, stores it and returns string index.
    fn encode_word(&mut self, word: String) -> String {
        let value = match self.stored_values.iter().position(|x| x == &word) {
            Some(int) => int,
            None => {
                self.stored_values.push(word);
                self.stored_values.len() - 1
            }
        };
        format!("{}", value)
    }

    fn decode_word(&mut self, index: usize) -> Option<String> {
        match self.stored_values.get(index) {
            Some(word) => Some(word.to_string()),
            None => None,
        }
    }
}
