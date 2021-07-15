# GlobalPhoneMS2_Scripts
Here we distribute the simulation scripts and speaker pair lists to recreate the GlobalPhone Mix-to-Separate out of 2 (GlobalPhoneMS2) database.

The simulations scripts are based on the ones to create the wsj0-2mix database as used in [1]. We slightly have changed the main script for our purposes. For the original scripts please consult [2].

## About GlobalPhoneMS2
The GlobalPhoneMS2 database contains two speaker mixtures for a total number of 22 languages. The mixtures were created as min versions with fs = 8 kHz. The total GlobalPhoneMS2 database comprises of 2000 different speakers.

Each test set contains 3000 samples. The rest is balanced to match 30 h and 10 h for the training and cross-validation sets respectively. Languages with just a little amount of data differ.
The speakers of the tr set are also part of the cv set but with different utterances represented. The speakers of the tt set are different to the tr and cv sets.
Next you can find an overview of the GlobalPhoneMS2 database properties:


| Languages |  # utterances tr/cv/tt | Audio (h) tr/cv/tt |
| ----- | ---: |---: |
| Arabic | 14285 / 4713 / 3000 | 30 / 10 / 6.63 |
| Bulgarian | 13758 / 4577 / 3000 | 30 / 10 / 6.58 |
| Chinese Mandarin | 13816 / 4621 / 3000 | 30 / 10 / 6.42 |
| Chinese Shanghai | 2772 / 1152 / 3000 | 5.95 / 2.48 / 6.27 |
| Croatian | 13477 / 4566 / 3000 | 30 / 10 / 6.52 |
| Czech | 13618 / 4561 / 3000 | 30 / 10 / 6.62 |
| French | 13532 / 4517 / 3000 | 30 / 10 / 6.62 |
| German | 13605 / 4533 / 3000 | 30 / 10 / 6.56 |
| Hausa | 30716 / 10025 / 3000 | 30 / 10 / 3.17 |
| Japanese | 13668 / 4575 / 3000 | 30 / 10 / 6.47 |
| Korean | 13717 / 4568 / 3000 | 30 / 10 / 6.58 |
| Polish | 13736 / 4556 / 3000 | 30 / 10 / 6.54 |
| Portuguese | 13845 / 4578 / 3000 | 30 / 10 / 6.51 |
| Russian | 13697 / 4572 / 3000 | 30 / 10 / 6.50 |
| Spanish | 14199 / 4897 / 3000 | 30 / 10 / 6.43 |
| Swahili | 19434 / 6364 / 3000 | 30 / 10 / 4.39 |
| Swedish | 13717 / 4567 / 3000 | 30 / 10 / 6.46 |
| Tamil | 737 / 222 / 3000 | 1.50 / 0.42 / 5.48 |
| Thai | 13751 / 4588 / 3000 | 30 / 10 / 6.57 |
| Turkish | 13874 / 4629 / 3000 | 30 / 10 / 6.42 |
| Ukrainian | 23294 / 7702 / 3000 | 30 / 10 / 3.97 |
| Vietnamese | 19899 / 6496 / 3000 | 30 / 10 / 4.08 |


## If you like working with the GlobalPhoneMS2 database, please cite us:  
M. Borsdorf, C. Xu, H. Li, and T. Schultz, "GlobalPhone Mix-to-Separate out of 2: A Multilingual 2000 Speaker Mixtures Database for Speech Separation", accepted to INTERSPEECH 2021.

You can find our paper here: *To be defined*

## References
[1] J. R. Hershey, Z. Chen, J. Le Roux, and S. Watanabe, "Deep Clustering: Discriminative Embeddings for Segmentation and Separation", IEEE International Conference on Acoustics, Speech, and Signal Processing (ICASSP), DOI: 10.1109/ICASSP.2016.7471631, March 2016, pp. 31-35.  
[2] Y. Isik, J. Le Roux, S. Watanabe Z. Chen, and J. R. Hershey, “Scripts to Create wsj0-2 Speaker Mixtures,” MERL Research. Retrieved June 2, 2020, from https://www.merl.com/demos/deep-clustering/create-speaker-mixtures.zip, [Online].

## License
The Apache 2.0 license applies to the script to create GlobalPhoneMS2. You can get access to the used GlobalPhone 2000 Speaker Package by purchasing a research or commercial license (https://catalog.elra.info/en-us/repository/browse/ELRA-S0400/).
