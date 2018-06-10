import numpy as np
import random

treasure = 3
n = 10
length_seq = 10
len_motif = 4
alphabet = ['a', 'c', 'g', 't']
motifs = []

def gen_motif(len_motif):
    motif = ''.join(np.random.choice(alphabet, len_motif))
    motifs.append(motif)
    return motif


def build_graph(n, graphMatrix, graphList):
    for i in range(0, n):
        relationed = np.random.randint(0, int(n/6))
        vertices = [i for i in range(0, n)]
        vertices.remove(i)
        for j in range(0, relationed):
            tmp = np.random.choice(vertices)
            graphMatrix[i][tmp] = 1
            graphList[i].append(tmp)
            vertices.remove(tmp)


def reachability_matrix(graph, n):
    reach_graph = np.copy(graph)
    for k in range(0,n): # building the reachability matrix
        for i in range(0, n):
            for j in range(0, n):
                reach_graph[i,j] = reach_graph[i,j] or (reach_graph[i, k] and reach_graph[k, j])
    return reach_graph


def about_motifs(n, treasure, len_motif, graphList, motifsList):
    motif = gen_motif(len_motif)
    #for i in range(0, treasure):
        #motifsList[i].append(motif)
    for i in range(0, n):
         if len(graphList) < 2:
             continue
         motif = gen_motif(len_motif)
         poses = np.random.choice([i for i in range(1, len(motif)-1)], 4)
         for j in graphList[i]:
             motifsList[j].append([motif, poses])


def get_expression(count, n, treasure, graphMatrix, graphList):
    reachabilityMatrix = reachability_matrix(graphMatrix, n)
    expression_vertex = set()#{0, 1, 2, 3}adgvqqq
    #print(reachabilityMatrix)
    for i in range(0, treasure):
        for j in range(0, n):
            if reachabilityMatrix[i][j] == 1:
                expression_vertex.add(j)
    arr = np.random.choice(list(expression_vertex), count, replace=False)
    timer = np.random.randint(4,5)
    print(timer)
    queue = []
    for iter in arr:
        queue.append([iter, True])

    for hit in range(timer):
        for iter in queue:
            if iter[1] == True:
                for leaf in graphList[iter[0]]:
                    queue.append([leaf, False])
                if len(graphList[iter[0]]) != 0:
                    queue.remove(iter)
            else:
                iter[1] = bool(random.getrandbits(1))&bool(random.getrandbits(1))

    expression = set()
    for iter in queue:
        expression.add(iter[0])
    #print(sorted(expression))
    return sorted(arr), sorted(expression)


def made_seq(length_seq, motifsList):
    seqs = []
    for motifs in motifsList:
        seq_no_motif = ''.join(np.random.choice(alphabet, length_seq))
        poses = []
        for motif in motifs:
            while True:
                pos = np.random.randint(0, len(seq_no_motif))
                flag = True
                for iter in poses:
                    if pos >= iter and pos <= (iter + len_motif):
                        flag = False
                        break
                if flag:
                    rand_pos = np.random.choice(motif[1], np.random.randint(0, 4))
                    lmotif = list(motif[0])
                    for letter in rand_pos:
                        m = alphabet[:]
                        m.remove(lmotif[letter])
                        lmotif[letter] = ''.join(np.random.choice(m, 1))
                    lmotif = ''.join(lmotif)
                    seq_no_motif = seq_no_motif[:pos]+lmotif+seq_no_motif[pos:]
                    poses.append(pos)
                    break
        seqs.append(seq_no_motif)
    return seqs

def get_test_date(_n, _treasure, _length_seq, _len_motif, count):
    graphMatrix = np.array([0 for i in range(0, _n * _n)]).reshape(_n, _n)
    graphList = [[] for _ in range(0, _n)]
    motifsList = [[] for _ in range(0, _n)]
    build_graph(_n, graphMatrix, graphList)
    about_motifs(_n, _treasure, _len_motif, graphList, motifsList)
    #test_seqs = made_seq(_length_seq, motifsList)
    tmp = ''.join(np.random.choice(alphabet, _n*_length_seq))
    test_seqs = [tmp[i:i+_length_seq] for i in range(0,_n*_length_seq+1,_length_seq)]
    hidden, ex = get_expression(count, _n, _treasure, graphMatrix, graphList)
    aim = gen_motif(_len_motif)
    rand_pos = np.random.choice([i for i in range(0, len(aim))], np.random.randint(0, 4))
    print(aim)
    for point in hidden:
        lmotif = list(aim)
        for letter in rand_pos:
            m = alphabet[:]
            m.remove(lmotif[letter])
            lmotif[letter] = ''.join(np.random.choice(m, 1))
        lmotif = ''.join(lmotif)
        pos = np.random.randint(0, len(test_seqs[point]) - _len_motif)
        test_seqs[point] = test_seqs[point][:pos] + lmotif + test_seqs[point][pos:]
    return graphList, test_seqs, hidden, ex, aim, graphMatrix

